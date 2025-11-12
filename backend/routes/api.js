const express = require('express');
const router = express.Router();
const Lead = require('../models/Lead');
const ContactSubmission = require('../models/ContactSubmission');
const auth = require('../middleware/auth');
const { sendConfirmationEmail, sendAdminNotification } = require('../utils/email');

// ============================================
// PUBLIC ENDPOINTS
// ============================================

// Health check
router.get('/ping', (req, res) => {
  res.json({ 
    status: 'ok', 
    message: 'StudioNex API is running',
    timestamp: new Date().toISOString()
  });
});

// POST /api/contact - Handle contact form submissions
router.post('/contact', async (req, res) => {
  try {
    const { name, email, discord, roblox, service, budget, details, deadline } = req.body;

    // Validation
    if (!name || !email || !discord || !service || !budget || !details) {
      return res.status(400).json({
        success: false,
        message: 'Missing required fields',
        required: ['name', 'email', 'discord', 'service', 'budget', 'details']
      });
    }

    // Check for duplicate recent submission (same email within 1 hour)
    const oneHourAgo = new Date(Date.now() - 60 * 60 * 1000);
    const recentSubmission = await ContactSubmission.findOne({
      email: email.toLowerCase(),
      submittedAt: { $gte: oneHourAgo }
    });

    if (recentSubmission) {
      return res.status(429).json({
        success: false,
        message: 'You have already submitted a request recently. Please wait before submitting again.'
      });
    }

    // Get client IP
    const ipAddress = req.ip || req.connection.remoteAddress || 'unknown';

    // Create submission
    const submission = new ContactSubmission({
      name,
      email,
      discord,
      roblox,
      service,
      budget,
      details,
      deadline: deadline ? new Date(deadline) : null,
      ipAddress
    });

    await submission.save();

    // Send emails (async, don't wait for response)
    if (process.env.SMTP_USER) {
      sendConfirmationEmail(submission).catch(err => 
        console.error('Failed to send confirmation email:', err.message)
      );
      sendAdminNotification(submission).catch(err => 
        console.error('Failed to send admin notification:', err.message)
      );
    }

    res.status(201).json({
      success: true,
      message: 'Your request has been submitted successfully! We will contact you soon.',
      submissionId: submission._id
    });

  } catch (error) {
    console.error('Contact submission error:', error);
    
    if (error.name === 'ValidationError') {
      return res.status(400).json({
        success: false,
        message: 'Validation error',
        errors: Object.values(error.errors).map(e => e.message)
      });
    }

    res.status(500).json({
      success: false,
      message: 'Server error. Please try again later.'
    });
  }
});

// POST /api/leads - Legacy lead creation (keep for backwards compatibility)
router.post('/leads', async (req, res) => {
  try {
    const { email, discord, source } = req.body;

    if (!email || !discord) {
      return res.status(400).json({
        success: false,
        message: 'Email and Discord are required'
      });
    }

    const lead = new Lead({ email, discord, source });
    await lead.save();

    res.status(201).json({
      success: true,
      message: 'Lead created successfully',
      lead: {
        id: lead._id,
        email: lead.email,
        discord: lead.discord
      }
    });

  } catch (error) {
    if (error.code === 11000) {
      return res.status(400).json({
        success: false,
        message: 'Email already registered'
      });
    }

    res.status(500).json({
      success: false,
      message: 'Server error'
    });
  }
});

// ============================================
// PROTECTED ADMIN ENDPOINTS
// ============================================

// GET /api/submissions - Get all contact submissions (paginated)
router.get('/submissions', auth, async (req, res) => {
  try {
    const { 
      status, 
      service, 
      page = 1, 
      limit = 20,
      search,
      sortBy = 'submittedAt',
      order = 'desc'
    } = req.query;

    const query = {};
    
    // Filters
    if (status) query.status = status;
    if (service) query.service = service;
    if (search) {
      query.$or = [
        { name: { $regex: search, $options: 'i' } },
        { email: { $regex: search, $options: 'i' } },
        { discord: { $regex: search, $options: 'i' } }
      ];
    }

    // Pagination
    const skip = (parseInt(page) - 1) * parseInt(limit);
    const sortOrder = order === 'desc' ? -1 : 1;

    const [submissions, total] = await Promise.all([
      ContactSubmission.find(query)
        .sort({ [sortBy]: sortOrder })
        .skip(skip)
        .limit(parseInt(limit))
        .select('-ipAddress'), // Don't expose IP to admin frontend
      ContactSubmission.countDocuments(query)
    ]);

    res.json({
      success: true,
      data: submissions,
      pagination: {
        total,
        page: parseInt(page),
        limit: parseInt(limit),
        pages: Math.ceil(total / parseInt(limit))
      }
    });

  } catch (error) {
    console.error('Get submissions error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error'
    });
  }
});

// GET /api/submissions/:id - Get single submission
router.get('/submissions/:id', auth, async (req, res) => {
  try {
    const submission = await ContactSubmission.findById(req.params.id);
    
    if (!submission) {
      return res.status(404).json({
        success: false,
        message: 'Submission not found'
      });
    }

    res.json({
      success: true,
      data: submission
    });

  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error'
    });
  }
});

// PUT /api/submissions/:id - Update submission status/notes
router.put('/submissions/:id', auth, async (req, res) => {
  try {
    const { status, notes } = req.body;
    const updates = {};

    if (status) updates.status = status;
    if (notes !== undefined) updates.notes = notes;

    const submission = await ContactSubmission.findByIdAndUpdate(
      req.params.id,
      updates,
      { new: true, runValidators: true }
    );

    if (!submission) {
      return res.status(404).json({
        success: false,
        message: 'Submission not found'
      });
    }

    res.json({
      success: true,
      message: 'Submission updated successfully',
      data: submission
    });

  } catch (error) {
    console.error('Update submission error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error'
    });
  }
});

// DELETE /api/submissions/:id - Delete submission (soft delete or hard)
router.delete('/submissions/:id', auth, async (req, res) => {
  try {
    const submission = await ContactSubmission.findByIdAndDelete(req.params.id);

    if (!submission) {
      return res.status(404).json({
        success: false,
        message: 'Submission not found'
      });
    }

    res.json({
      success: true,
      message: 'Submission deleted successfully'
    });

  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error'
    });
  }
});

// GET /api/leads - Get all leads (protected)
router.get('/leads', auth, async (req, res) => {
  try {
    const leads = await Lead.find().sort({ createdAt: -1 });
    res.json({
      success: true,
      count: leads.length,
      leads
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error'
    });
  }
});

// GET /api/stats - Dashboard statistics
router.get('/stats', auth, async (req, res) => {
  try {
    const [
      totalSubmissions,
      pendingCount,
      contactedCount,
      completedCount,
      recentSubmissions
    ] = await Promise.all([
      ContactSubmission.countDocuments(),
      ContactSubmission.countDocuments({ status: 'pending' }),
      ContactSubmission.countDocuments({ status: 'contacted' }),
      ContactSubmission.countDocuments({ status: 'completed' }),
      ContactSubmission.find()
        .sort({ submittedAt: -1 })
        .limit(5)
        .select('name email service status submittedAt')
    ]);

    res.json({
      success: true,
      stats: {
        total: totalSubmissions,
        pending: pendingCount,
        contacted: contactedCount,
        completed: completedCount,
        recent: recentSubmissions
      }
    });

  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error'
    });
  }
});

module.exports = router;