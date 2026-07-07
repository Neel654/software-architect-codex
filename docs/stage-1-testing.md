# Stage 1 — Testing: Authentication Service

## Why Testing Exists

Untested code is legacy code. Testing is how you prove your system works before users find out it doesn't.

## The Test Pyramid

```
        ╱╲
       ╱ E2E ╲
      ╱────────╲
     ╱Integration╲       ← Service-level, DB, Redis
    ╱──────────────╲
   ╱   Unit Tests    ╲   ← Functions, handlers, utils
  ╱────────────────────╲
```

| Layer | Speed | Scope | Count |
|-------|-------|-------|-------|
| Unit | ms | Single function | Many |
| Integration | s | Service + dependencies | Some |
| E2E | min | Full system | Few |

## Contract Testing (Pact)

Microservices communicate via contracts. Pact verifies that providers satisfy consumer expectations without deploying both sides.

```
Consumer (API Gateway) → writes Pact file → Provider (Auth Service) verifies
```

## Testcontainers Pattern

Spin up real Postgres/Redis containers for integration tests — no mocks, real dependencies.

```typescript
// testcontainers example
import { PostgreSqlContainer, RedisContainer } from '@testcontainers/postgresql';

const postgres = await new PostgreSqlContainer('postgres:16-alpine')
  .withDatabase('nexus_test')
  .start();

const redis = await new RedisContainer('redis:7-alpine')
  .start();

// Use postgres.getConnectionUri() and redis.getConnectionUrl() in tests
```

## Recommended Tools

| Tool | Use |
|------|-----|
| Jest / Vitest | Unit + integration tests (Node.js) |
| Go test | Unit + integration (Go) |
| Pact | Contract testing |
| Testcontainers | Integration test dependencies |
| pgTAP | PostgreSQL function testing |

## Exercises

### Exercise 1: Unit Tests for Auth Handlers

Write tests for `auth.service.ts`:

- `register` creates user and returns tokens
- `login` validates credentials
- `refreshTokens` rotates tokens
- `verifyEmail` marks user as verified

```bash
npx jest examples/tests/auth.unit.test.js --coverage
```

### Exercise 2: Integration Tests with Testcontainers

Spin up Postgres + Redis containers, run full auth flow:

1. Register user
2. Login
3. Refresh token
4. Verify email

### Exercise 3: Pact Contract Test

Create a Pact contract between auth-service (provider) and user-service (consumer):

```typescript
// Consumer test
const interaction = {
  state: 'user exists',
  uponReceiving: 'a request for user profile',
  withRequest: {
    method: 'GET',
    path: '/users/123',
    headers: { Authorization: 'Bearer token' }
  },
  willRespondWith: {
    status: 200,
    body: { id: '123', email: 'test@example.com' }
  }
};
```

### Exercise 4: Migration Test

Write a test that:

1. Applies migration `CREATE TABLE users (...)`
2. Seeds test data
3. Queries the table
4. Rolls back the migration
5. Verifies table is gone
