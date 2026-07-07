# Grafana Dashboard — Nexus Auth Service

## Quick Start

1. Add Prometheus as a data source in Grafana
2. Import the dashboard JSON (below) or create manually
3. Set the `service` variable to `auth-service`

## Recommended Panels

| Panel | Metric | Query |
|-------|--------|-------|
| Request Latency (p50/p95/p99) | Histogram | `histogram_quantile(0.50, sum(rate(nexus_http_request_duration_seconds_bucket{service="auth-service"}[5m])) by (le))` |
| Request Rate | Counter | `rate(nexus_http_request_duration_seconds_count{service="auth-service"}[5m])` |
| Error Rate | Counter | `sum(rate(nexus_http_request_duration_seconds_count{service="auth-service", code=~"5.."}[5m])) / sum(rate(nexus_http_request_duration_seconds_count{service="auth-service"}[5m]))` |
| Login Success Rate | Counter | `rate(nexus_auth_login_attempts_total{service="auth-service", status="success"}[5m]) / rate(nexus_auth_login_attempts_total{service="auth-service"}[5m])` |

## Tracing Header Propagation

Ensure every HTTP client propagates these headers:

```javascript
const headers = {
  'x-request-id': requestId,
  'x-trace-id': traceId,
  'x-span-id': spanId,
};
```

Services receiving these headers should include them in logs and propagated requests.
