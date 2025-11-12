module.exports = function (req, res, next) {
  const header = req.header('x-api-key') || (req.header('authorization') || '').replace('Bearer ', '');
  const adminKey = process.env.ADMIN_API_KEY;
  if (!header || !adminKey || header !== adminKey) {
    return res.status(401).json({ error: 'Unauthorized' });
  }
  next();
};
