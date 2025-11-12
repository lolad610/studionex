const mongoose = require('mongoose');
const { Schema } = mongoose;

const LeadSchema = new Schema({
  name: { type: String, required: true, trim: true },
  email: { type: String, required: true, trim: true },
  message: { type: String, default: '', trim: true },
  source: { type: String, default: 'landing' },
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Lead', LeadSchema);
