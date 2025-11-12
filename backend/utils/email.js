const nodemailer = require('nodemailer');

// Create reusable transporter
const createTransporter = () => {
  if (!process.env.SMTP_USER || !process.env.SMTP_PASS) {
    console.warn('Email credentials not configured. Email notifications disabled.');
    return null;
  }

  return nodemailer.createTransport({
    host: process.env.SMTP_HOST || 'smtp.gmail.com',
    port: parseInt(process.env.SMTP_PORT) || 587,
    secure: false, // true for 465, false for other ports
    auth: {
      user: process.env.SMTP_USER,
      pass: process.env.SMTP_PASS
    }
  });
};

// Send confirmation email to client
const sendConfirmationEmail = async (submission) => {
  const transporter = createTransporter();
  if (!transporter) return;

  const mailOptions = {
    from: `"StudioNex" <${process.env.SMTP_USER}>`,
    to: submission.email,
    subject: '✅ Your StudioNex Request Has Been Received',
    html: `
      <!DOCTYPE html>
      <html>
      <head>
        <style>
          body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
          .container { max-width: 600px; margin: 0 auto; padding: 20px; }
          .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }
          .content { background: #f9f9f9; padding: 30px; border-radius: 0 0 10px 10px; }
          .details { background: white; padding: 20px; border-left: 4px solid #667eea; margin: 20px 0; }
          .footer { text-align: center; margin-top: 30px; color: #666; font-size: 12px; }
          h1 { margin: 0; font-size: 24px; }
          .label { font-weight: bold; color: #667eea; }
        </style>
      </head>
      <body>
        <div class="container">
          <div class="header">
            <h1>🎮 StudioNex</h1>
            <p>Professional Roblox Development</p>
          </div>
          <div class="content">
            <h2>Thank you for your request, ${submission.name}!</h2>
            <p>We've received your project inquiry and our team will review it shortly. Here's a summary of your submission:</p>
            
            <div class="details">
              <p><span class="label">Service:</span> ${submission.service}</p>
              <p><span class="label">Budget:</span> ${submission.budget}</p>
              <p><span class="label">Discord:</span> ${submission.discord}</p>
              ${submission.roblox ? `<p><span class="label">Roblox:</span> ${submission.roblox}</p>` : ''}
              ${submission.deadline ? `<p><span class="label">Deadline:</span> ${new Date(submission.deadline).toLocaleDateString()}</p>` : ''}
              <p><span class="label">Project Details:</span><br>${submission.details}</p>
            </div>

            <p><strong>What happens next?</strong></p>
            <ul>
              <li>We'll review your project requirements within 24-48 hours</li>
              <li>You'll receive a response via Discord or email</li>
              <li>We'll discuss timeline, pricing, and next steps</li>
            </ul>

            <p>If you have any urgent questions, feel free to reach out on Discord!</p>
          </div>
          <div class="footer">
            <p>StudioNex - Elite Roblox Development Services</p>
            <p>Discord: shrinivasdhangar62 | Email: shrinivasdhangar62@gmail.com</p>
          </div>
        </div>
      </body>
      </html>
    `
  };

  try {
    await transporter.sendMail(mailOptions);
    console.log(`Confirmation email sent to ${submission.email}`);
  } catch (error) {
    console.error('Error sending confirmation email:', error.message);
    throw error;
  }
};

// Send notification to admin
const sendAdminNotification = async (submission) => {
  const transporter = createTransporter();
  if (!transporter) return;

  const adminEmail = process.env.ADMIN_EMAIL || 'shrinivasdhangar62@gmail.com';

  const mailOptions = {
    from: `"StudioNex Notifications" <${process.env.SMTP_USER}>`,
    to: adminEmail,
    subject: `🔔 New Client Request: ${submission.service} (${submission.budget})`,
    html: `
      <!DOCTYPE html>
      <html>
      <head>
        <style>
          body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
          .container { max-width: 600px; margin: 0 auto; padding: 20px; }
          .alert { background: #ff6b6b; color: white; padding: 20px; text-align: center; border-radius: 10px; margin-bottom: 20px; }
          .details { background: #f9f9f9; padding: 20px; border-left: 4px solid #51cf66; }
          .label { font-weight: bold; color: #495057; }
          .urgent { background: #ffd43b; padding: 10px; border-radius: 5px; margin: 10px 0; }
        </style>
      </head>
      <body>
        <div class="container">
          <div class="alert">
            <h2>🚨 NEW CLIENT REQUEST</h2>
            <p>Action Required</p>
          </div>
          
          <div class="details">
            <h3>Client Information</h3>
            <p><span class="label">Name:</span> ${submission.name}</p>
            <p><span class="label">Email:</span> <a href="mailto:${submission.email}">${submission.email}</a></p>
            <p><span class="label">Discord:</span> ${submission.discord}</p>
            ${submission.roblox ? `<p><span class="label">Roblox:</span> ${submission.roblox}</p>` : ''}
            
            <h3>Project Details</h3>
            <p><span class="label">Service:</span> ${submission.service}</p>
            <p><span class="label">Budget:</span> ${submission.budget}</p>
            ${submission.deadline ? `<div class="urgent"><span class="label">⚠️ Deadline:</span> ${new Date(submission.deadline).toLocaleDateString()}</div>` : ''}
            <p><span class="label">Description:</span><br>${submission.details}</p>
            
            <p><span class="label">Submitted:</span> ${new Date(submission.submittedAt).toLocaleString()}</p>
            <p><span class="label">Submission ID:</span> ${submission._id}</p>
          </div>

          <p style="text-align: center; margin-top: 20px;">
            <a href="${process.env.ADMIN_DASHBOARD_URL || 'http://localhost:3000/admin.html'}" 
               style="background: #667eea; color: white; padding: 12px 30px; text-decoration: none; border-radius: 5px; display: inline-block;">
              View in Admin Dashboard
            </a>
          </p>
        </div>
      </body>
      </html>
    `
  };

  try {
    await transporter.sendMail(mailOptions);
    console.log(`Admin notification sent for submission ${submission._id}`);
  } catch (error) {
    console.error('Error sending admin notification:', error.message);
    throw error;
  }
};

module.exports = {
  sendConfirmationEmail,
  sendAdminNotification
};