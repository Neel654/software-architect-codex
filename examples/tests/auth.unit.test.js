/**
 * Nexus Auth Service — Unit Tests
 *
 * Prerequisites:
 *   export JWT_ACCESS_SECRET=test-access-secret-key-1234567890
 *   export JWT_REFRESH_SECRET=test-refresh-secret-key-0987654321
 *
 * Run: npx jest examples/tests/auth.unit.test.js --coverage
 */

const jwt = require('jsonwebtoken');

// --------------- Token Service (simplified) ---------------
const JWT_ACCESS_SECRET = process.env.JWT_ACCESS_SECRET || 'default-test-secret';
const JWT_REFRESH_SECRET = process.env.JWT_REFRESH_SECRET || 'default-test-secret';

function generateAccessToken(payload) {
  return jwt.sign(payload, JWT_ACCESS_SECRET, {
    expiresIn: '15m',
    issuer: 'nexus-auth',
    audience: 'nexus-api',
  });
}

function generateRefreshToken(userId) {
  const crypto = require('crypto');
  const token = crypto.randomBytes(40).toString('hex');
  return `${userId}.${token}`;
}

function verifyAccessToken(token) {
  return jwt.verify(token, JWT_ACCESS_SECRET);
}

// --------------- Password Service (simplified) ---------------
const bcrypt = require('bcrypt');
const SALT_ROUNDS = 10;

async function hashPassword(password) {
  const salt = await bcrypt.genSalt(SALT_ROUNDS);
  return bcrypt.hash(password, salt);
}

async function verifyPassword(password, hash) {
  return bcrypt.compare(password, hash);
}

// --------------- Rate Limiter (simplified) ---------------
class InMemoryRateLimiter {
  constructor(maxAttempts = 5, windowMs = 60000) {
    this.maxAttempts = maxAttempts;
    this.windowMs = windowMs;
    this.store = new Map();
  }

  async check(key) {
    const now = Date.now();
    const record = this.store.get(key);

    if (!record || now - record.windowStart > this.windowMs) {
      this.store.set(key, { count: 1, windowStart: now });
      return { allowed: true, remaining: this.maxAttempts - 1 };
    }

    record.count += 1;
    if (record.count > this.maxAttempts) {
      return { allowed: false, remaining: 0, retryAfter: this.windowMs - (now - record.windowStart) };
    }

    return { allowed: true, remaining: this.maxAttempts - record.count };
  }
}

// --------------- Tests ---------------
describe('Token Service', () => {
  test('generateAccessToken creates a valid JWT with correct claims', () => {
    const payload = { userId: 'abc-123', email: 'test@example.com', role: 'user' };
    const token = generateAccessToken(payload);
    const decoded = verifyAccessToken(token);

    expect(decoded.userId).toBe('abc-123');
    expect(decoded.email).toBe('test@example.com');
    expect(decoded.role).toBe('user');
    expect(decoded.iss).toBe('nexus-auth');
    expect(decoded.aud).toBe('nexus-api');
  });

  test('generateAccessToken respects expiry', () => {
    const payload = { userId: 'abc-123', email: 'test@example.com', role: 'user' };
    const token = jwt.sign(payload, JWT_ACCESS_SECRET, { expiresIn: '0s' });

    expect(() => verifyAccessToken(token)).toThrow('jwt expired');
  });

  test('generateRefreshToken produces userId.token format', () => {
    const token = generateRefreshToken('abc-123');
    const parts = token.split('.');

    expect(parts.length).toBe(2);
    expect(parts[0]).toBe('abc-123');
    expect(parts[1].length).toBe(80); // 40 bytes = 80 hex chars
  });

  test('verifyAccessToken rejects tampered token', () => {
    const payload = { userId: 'abc-123', email: 'test@example.com', role: 'user' };
    const token = generateAccessToken(payload);
    const tampered = token.slice(0, -5) + 'AAAAA';

    expect(() => verifyAccessToken(tampered)).toThrow();
  });
});

describe('Password Service', () => {
  test('hashPassword returns a hash that verifyPassword accepts', async () => {
    const password = 'MySecureP@ss123!';
    const hash = await hashPassword(password);

    expect(hash).not.toBe(password);
    expect(hash.startsWith('$2b$')).toBe(true);

    const valid = await verifyPassword(password, hash);
    expect(valid).toBe(true);
  });

  test('verifyPassword rejects wrong password', async () => {
    const hash = await hashPassword('CorrectP@ss1');
    const valid = await verifyPassword('WrongP@ss1', hash);
    expect(valid).toBe(false);
  });

  test('hashPassword produces different hashes for same password', async () => {
    const password = 'SameP@ss1';
    const hash1 = await hashPassword(password);
    const hash2 = await hashPassword(password);

    expect(hash1).not.toBe(hash2);
  });
});

describe('Rate Limiter', () => {
  test('allows requests within limit', async () => {
    const limiter = new InMemoryRateLimiter(3, 60000);

    expect((await limiter.check('test-key')).allowed).toBe(true);
    expect((await limiter.check('test-key')).allowed).toBe(true);
    expect((await limiter.check('test-key')).allowed).toBe(true);
  });

  test('blocks requests exceeding limit', async () => {
    const limiter = new InMemoryRateLimiter(2, 60000);

    expect((await limiter.check('block-key')).allowed).toBe(true);
    expect((await limiter.check('block-key')).allowed).toBe(true);
    const third = await limiter.check('block-key');

    expect(third.allowed).toBe(false);
    expect(third.retryAfter).toBeGreaterThan(0);
  });

  test('resets window after timeout', async () => {
    const limiter = new InMemoryRateLimiter(1, 100); // 100ms window

    expect((await limiter.check('reset-key')).allowed).toBe(true);
    expect((await limiter.check('reset-key')).allowed).toBe(false);

    await new Promise((r) => setTimeout(r, 150));

    expect((await limiter.check('reset-key')).allowed).toBe(true);
  });

  test('tracks different keys independently', async () => {
    const limiter = new InMemoryRateLimiter(1, 60000);

    expect((await limiter.check('alice')).allowed).toBe(true);
    expect((await limiter.check('bob')).allowed).toBe(true);
    expect((await limiter.check('alice')).allowed).toBe(false);
    expect((await limiter.check('bob')).allowed).toBe(false);
  });
});
