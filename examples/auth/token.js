/**
 * Nexus Auth — Token Service
 *
 * Environment variables:
 *   JWT_ACCESS_SECRET  — Secret for signing access tokens (min 32 chars)
 *   JWT_REFRESH_SECRET — Secret for refresh token signing (optional, for future use)
 */

const jwt = require('jsonwebtoken');
const crypto = require('crypto');

const JWT_ACCESS_SECRET = process.env.JWT_ACCESS_SECRET || (() => {
  throw new Error('JWT_ACCESS_SECRET environment variable is required');
})();

const JWT_REFRESH_SECRET = process.env.JWT_REFRESH_SECRET || JWT_ACCESS_SECRET;

/**
 * Generate a short-lived JWT access token.
 * @param {object} payload - { userId, email, role }
 * @returns {string} signed JWT
 */
function generateAccessToken(payload) {
  if (!payload.userId || !payload.email) {
    throw new Error('Payload must include userId and email');
  }

  return jwt.sign(
    {
      userId: payload.userId,
      email: payload.email,
      role: payload.role || 'user',
    },
    JWT_ACCESS_SECRET,
    {
      expiresIn: '15m',
      issuer: 'nexus-auth',
      audience: 'nexus-api',
    },
  );
}

/**
 * Generate an opaque refresh token in userId.randomHex format.
 * @param {string} userId
 * @returns {string} token
 */
function generateRefreshToken(userId) {
  if (!userId) throw new Error('userId is required');

  const token = crypto.randomBytes(40).toString('hex');
  return `${userId}.${token}`;
}

/**
 * Verify and decode a JWT access token.
 * @param {string} token
 * @returns {object} decoded payload
 */
function verifyAccessToken(token) {
  if (!token) throw new Error('Token is required');

  return jwt.verify(token, JWT_ACCESS_SECRET, {
    issuer: 'nexus-auth',
    audience: 'nexus-api',
  });
}

/**
 * Hash a refresh token for storage (SHA-256).
 * @param {string} rawToken
 * @returns {string} hex digest
 */
function hashRefreshToken(rawToken) {
  return crypto.createHash('sha256').update(rawToken).digest('hex');
}

module.exports = {
  generateAccessToken,
  generateRefreshToken,
  verifyAccessToken,
  hashRefreshToken,
};
