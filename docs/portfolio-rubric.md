# Nexus Portfolio Rubric

Use this rubric to evaluate your Nexus project across each stage.

## Scoring

| Criterion | Weight | 0 (Missing) | 1 (Incomplete) | 2 (Adequate) | 3 (Excellent) |
|-----------|--------|-------------|----------------|---------------|----------------|
| **Correctness** | 40% | Not implemented | Partially works | All features work under normal conditions | Handles edge cases, errors, and concurrent access |
| **Tests** | 20% | No tests | Skeleton tests only | Unit tests for core logic | Unit + integration + contract tests |
| **CI / Deploy** | 15% | No CI | CI wired but failing | CI passes all checks | CI + automated deploy to staging |
| **Observability** | 15% | No logging/metrics | Basic console logs | Structured logs + metrics | Logs + metrics + tracing + dashboard |
| **Docs / ADR** | 10% | No docs | Minimal README | Architecture docs + API docs | ADRs + diagrams + runbooks |

## Per-Stage Deliverables

### Stage 1: Auth Service
- [ ] Registration with email verification
- [ ] Login with rate limiting
- [ ] JWT access + refresh token rotation
- [ ] OAuth integration (Google/GitHub)
- [ ] Password reset flow
- [ ] 2FA with TOTP
- [ ] Unit tests (token, password, rate limiter)
- [ ] Integration tests (Postgres + Redis via Testcontainers)
- [ ] CI pipeline (GitHub Actions)

### Stage 2: Database Engineering
- [ ] ER diagrams for social features
- [ ] PostgreSQL schemas with proper indexes
- [ ] Redis caching layer
- [ ] Migration scripts
- [ ] Performance benchmarks

### Stage 3: Cloud (AWS)
- [ ] VPC with public/private subnets
- [ ] RDS with read replicas
- [ ] S3 with presigned URLs
- [ ] ALB + Auto Scaling
- [ ] CloudWatch dashboards

### Stage 4: Docker
- [ ] Multi-stage Dockerfiles
- [ ] docker-compose.yml for local dev
- [ ] Health checks
- [ ] Resource limits
- [ ] Non-root users

### Stage 5: Distributed Systems
- [ ] Microservice decomposition
- [ ] Message queue integration (Kafka/RabbitMQ)
- [ ] Circuit breakers
- [ ] Saga pattern for transactions
- [ ] API Gateway

### Stage 6: AI
- [ ] Document ingestion pipeline
- [ ] Chunking + embeddings
- [ ] Vector DB (PGVector)
- [ ] RAG query pipeline
- [ ] AI agents with tool calling

### Stage 7: Search
- [ ] Elasticsearch cluster
- [ ] Full-text search with BM25
- [ ] Vector/hybrid search
- [ ] Autocomplete + faceted search

### Stage 8: Observability
- [ ] Structured JSON logging
- [ ] Prometheus metrics
- [ ] Grafana dashboards
- [ ] Distributed tracing
- [ ] SLOs + alerting rules

### Stage 9: Kubernetes
- [ ] Deployments + Services
- [ ] Ingress with TLS
- [ ] HPA (auto-scaling)
- [ ] PodDisruptionBudget
- [ ] CI/CD pipeline

### Stage 10: Architecture
- [ ] ADRs for all major decisions
- [ ] C4 diagrams
- [ ] Disaster recovery plan
- [ ] Cost analysis
- [ ] Security threat model

## Minimum Submission Requirements

To submit a stage as a portfolio entry:
- **Score ≥ 60%** (weighted average across criteria)
- **Correctness ≥ 2** (all core features working)
- **Tests ≥ 1** (at least skeleton tests present)
- All deliverables in the stage checklist must be attempted

## Portfolio Tips

1. **Each stage is a separate git tag** — tag your commits: `stage-1`, `stage-2`, etc.
2. **Write a README per stage** explaining architecture decisions
3. **Include screenshots** of working dashboards, test output, and deployment
4. **Record a demo video** (2-3 min) walking through the key features
5. **Host the deployment** (AWS free tier is sufficient for staging)
