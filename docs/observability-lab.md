# Observability Lab — Instrument Nexus Auth Service

## Learning Objectives

1. Add structured logging to the auth service
2. Export Prometheus metrics (RED method)
3. Create a Grafana dashboard
4. Configure Prometheus alerting rules

## Instrumentation Conventions

### Metric Names

Use the format: `{namespace}_{subsystem}_{metric_name}`

```
nexus_auth_login_attempts_total
nexus_auth_token_created_total
nexus_http_request_duration_seconds
nexus_db_query_duration_seconds
```

### Label Conventions

Every metric should carry:
- `service` — service name (e.g., `auth-service`)
- `environment` — `staging`, `production`
- `method` — HTTP method or operation name

### Tag Value Rules

- Use lowercase snake_case
- No trailing/leading whitespace
- Avoid high-cardinality labels (user IDs, emails)

## Exercise: Instrument Auth Service

1. **Add Prometheus client**
   ```bash
   npm install prom-client
   ```

2. **Add metrics middleware**
   ```javascript
   const client = require('prom-client');

   const httpRequestDuration = new client.Histogram({
     name: 'nexus_http_request_duration_seconds',
     help: 'HTTP request duration in seconds',
     labelNames: ['method', 'route', 'code', 'service'],
     buckets: [0.01, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5],
   });

   const loginAttempts = new client.Counter({
     name: 'nexus_auth_login_attempts_total',
     help: 'Total login attempts',
     labelNames: ['status', 'service'],
   });
   ```

3. **Expose `/metrics` endpoint**
   ```javascript
   app.get('/metrics', async (req, res) => {
     res.set('Content-Type', client.register.contentType);
     res.end(await client.register.metrics());
   });
   ```

4. **Add tracing headers** — propagate `x-request-id` and `x-trace-id` across service calls

5. **Create a Grafana dashboard** with:
   - Panel 1: Request latency p50/p95/p99 (rate)
   - Panel 2: Error rate (5xx / total)
   - Panel 3: Login success rate
   - Panel 4: Active database connections

## Verifying

```bash
# Check metrics endpoint
curl http://localhost:3000/metrics | head -20

# Trigger some logins
for i in 1 2 3; do
  curl -X POST http://localhost:3000/auth/login \
    -H 'Content-Type: application/json' \
    -d '{"email":"test@example.com","password":"wrong"}'
done

# Re-check metrics
curl http://localhost:3000/metrics | grep nexus_auth
```
