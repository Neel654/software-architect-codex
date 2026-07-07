# The Software Architect Codex

> From Code to Cloud — A Complete Handbook for Building World-Class Software Systems

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
![Status](https://img.shields.io/badge/Status-In%20Progress-blue)
![Stages](https://img.shields.io/badge/Stages-10-brightgreen)

A comprehensive learning journey from writing your first production API to designing distributed AI platforms. This repo contains the full book (THE-SOFTWARE-ARCHITECT-CODEX.md) and the companion **Nexus** project — an evolving platform you build stage by stage.

---

## The Book

The **Software Architect Codex** collects battle-tested knowledge from engineers at Google, Amazon, Netflix, Meta, OpenAI, Stripe, and MIT into one complete curriculum.

**10 Stages:**

| # | Stage | Description | Status |
|---|-------|-------------|--------|
| 1 | Backend Fundamentals | Auth service (JWT, OAuth, 2FA, rate limiting, Redis, PostgreSQL) | ✅ |
| 2 | Database Engineering | Schema design, indexing, caching, migration strategies | ✅ |
| 3 | Cloud (AWS) | VPC, RDS, S3, ALB, Auto Scaling, IAM | ✅ |
| 4 | Docker & Containers | Multi-stage builds, compose, health checks, resource limits | ✅ |
| 5 | Distributed Systems | Microservices, message queues, circuit breakers, sagas, API gateway | ✅ |
| 6 | AI & LLMs | Embeddings, vector DB (PGVector), RAG, AI agents | ✅ |
| 7 | Search | Elasticsearch, BM25, hybrid search, autocomplete | ✅ |
| 8 | Observability | Structured logging, Prometheus, Grafana, tracing, SLOs | ✅ |
| 9 | Kubernetes | Deployments, Ingress, HPA, PDB, CI/CD | ✅ |
| 10 | Architecture | ADRs, C4 diagrams, DR plans, cost analysis, threat modeling | ✅ |

Each stage builds on the last. By the end you'll have deployed a distributed AI platform ready for production.

---

## The Nexus Project

Nexus starts as a simple auth service and evolves into a full distributed AI platform. Every concept in the book translates directly into working code.

```
Stage 1: Auth (Node.js + Postgres + Redis + JWT)
    ↓
Stage 2: Social features, caching, migrations
    ↓
Stage 3: AWS infrastructure (Terraform)
    ↓
Stage 4: Containerization (Docker, Compose)
    ↓
Stage 5: Microservices, queues, circuit breakers
    ↓
Stage 6: AI pipeline (embeddings, RAG, agents)
    ↓
Stage 7: Search (Elasticsearch)
    ↓
Stage 8: Observability (Prometheus, Grafana, tracing)
    ↓
Stage 9: Kubernetes deployment
    ↓
Stage 10: Architecture docs, ADRs, DR plans
```

---

## Repository Structure

```
.
├── THE-SOFTWARE-ARCHITECT-CODEX.md   # Full book (~1500 lines, all 10 stages)
├── examples/                          # Runnable code, tests, Docker configs
│   ├── auth/                          # Auth service (token, password helpers)
│   ├── tests/                         # Unit + integration tests
│   ├── Dockerfile                     # Multi-stage build
│   ├── docker-compose.dev.yml         # Local dev environment
│   ├── package.json                   # Dependencies
│   └── jest.config.js                 # Test configuration
├── infra/                             # Terraform (AWS)
│   ├── modules/                       # Reusable modules (network, postgres, redis)
│   ├── environments/                  # Staging environment
│   └── monitoring/                    # Prometheus alerting rules
├── docs/                              # Labs, guides, rubric
│   ├── stage-1-testing.md             # Testing lab
│   ├── observability-lab.md           # Observability exercises
│   ├── grafana-dashboard-guidance.md   # Dashboard setup
│   └── portfolio-rubric.md            # Self-evaluation rubric
├── doc/adr/                           # Architecture Decision Records
│   ├── template.md                    # ADR template
│   └── 0001-record-architecture-decision.md  # Sample ADR
└── .github/workflows/                 # CI pipeline
    └── ci.yml                         # GitHub Actions (test + lint)
```

---

## Quick Start

```bash
# Clone the repo
git clone https://github.com/Neel654/software-architect-codex.git
cd software-architect-codex

# Start reading
open THE-SOFTWARE-ARCHITECT-CODEX.md

# Run Stage 1 tests
cd examples
npm install
npm test

# Start local dev environment
docker compose -f docker-compose.dev.yml up
```

---

## Progress Tracking

Track your own progress using the [Portfolio Rubric](docs/portfolio-rubric.md). Each stage has a checklist of deliverables and a scoring system to evaluate your implementation against professional standards.

---

## Key Docs

- [Full Book (THE-SOFTWARE-ARCHITECT-CODEX.md)](THE-SOFTWARE-ARCHITECT-CODEX.md)
- [Testing Lab](docs/stage-1-testing.md)
- [Observability Lab](docs/observability-lab.md)
- [Grafana Dashboard Guide](docs/grafana-dashboard-guidance.md)
- [Portfolio Rubric](docs/portfolio-rubric.md)
- [ADR Template](doc/adr/template.md)
- [Infrastructure Guide](infra/README.md)

---

## Built With

- **Runtime:** Node.js
- **Database:** PostgreSQL + Redis
- **Cloud:** AWS (Terraform)
- **Containers:** Docker, Docker Compose
- **AI:** OpenAI API, PGVector
- **Search:** Elasticsearch
- **Observability:** Prometheus, Grafana, OpenTelemetry
- **Orchestration:** Kubernetes
- **CI/CD:** GitHub Actions

---

## License

MIT
