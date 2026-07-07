/**
 * Nexus Auth — Password Service
 *
 * Uses bcrypt with cost factor 12 for password hashing.
 */

const bcrypt = require('bcrypt');

const SALT_ROUNDS = 12;

/**
 * Hash a plaintext password using bcrypt.
 * @param {string} password - plaintext password
 * @returns {Promise<string>} bcrypt hash
 */
async function hashPassword(password) {
  if (!password || password.length < 8) {
    throw new Error('Password must be at least 8 characters');
  }

  const salt = await bcrypt.genSalt(SALT_ROUNDS);
  return bcrypt.hash(password, salt);
}

/**
 * Verify a password against a bcrypt hash.
 * @param {string} password - plaintext password to check
 * @param {string} hash - stored bcrypt hash
 * @returns {Promise<boolean>}
 */
async function verifyPassword(password, hash) {
  if (!password || !hash) {
    throw new Error('Password and hash are required');
  }

  return bcrypt.compare(password, hash);
}

module.exports = {
  hashPassword,
  verifyPassword,
};
