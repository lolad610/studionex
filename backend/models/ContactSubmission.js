const mongoose = require('mongoose');

const contactSubmissionSchema = new mongoose.Schema({
  name: {
    type: String,
    required: [true, 'Name is required'],
    trim: true,
    maxlength: [100, 'Name cannot exceed 100 characters']
  },
  email: {
    type: String,
    required: [true, 'Email is required'],
    trim: true,
    lowercase: true,
    match: [/^\S+@\S+\.\S+$/, 'Please provide a valid email']
  },
  discord: {
    type: String,
    required: [true, 'Discord username is required'],
    trim: true,
    maxlength: [50, 'Discord username too long']
  },
  roblox: {
    type: String,
    trim: true,
    maxlength: [50, 'Roblox username too long']
  },
  service: {
    type: String,
    required: [true, 'Service selection is required'],
    enum: [
      'Game Systems Development',
      'UI/UX Design',
      'Admin Commands',
      'Data Systems',
      'Anti-Cheat Systems',
      'Bug Fixes & Optimization',
      'Full Project Development',
      'Other'
    ]
  },
  budget: {
    type: String,
    required: [true, 'Budget is required'],
    enum: ['$100-$500', '$500-$1000', '$1000-$2500', '$2500+']
  },
  details: {
    type: String,
    required: [true, 'Project details are required'],
    maxlength: [2000, 'Details cannot exceed 2000 characters']
  },
  deadline: {
    type: Date,
    validate: {
      validator: function(v) {
        return !v || v >= new Date();
      },
      message: 'Deadline must be in the future'
    }
  },
  submittedAt: {
    type: Date,
    default: Date.now
  },
  status: {
    type: String,
    enum: ['pending', 'contacted', 'in-progress', 'completed', 'rejected'],
    default: 'pending'
  },
  notes: {
    type: String,
    maxlength: [1000, 'Notes cannot exceed 1000 characters']
  },
  ipAddress: {
    type: String,
    required: true
  }
}, {
  timestamps: true
});

// Index for faster queries
contactSubmissionSchema.index({ email: 1 });
contactSubmissionSchema.index({ status: 1 });
contactSubmissionSchema.index({ submittedAt: -1 });

module.exports = mongoose.model('ContactSubmission', contactSubmissionSchema);