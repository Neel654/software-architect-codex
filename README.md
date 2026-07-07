# The Software Architect Codex

> A Self-Directed Learning Path: From Simple APIs to Distributed AI Systems

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
![Status](https://img.shields.io/badge/Status-Active%20Learning-blue)
![Stages](https://img.shields.io/badge/Stages-10-brightgreen)

A structured 10-stage syllabus for learning software architecture through hands-on projects. This repository documents my learning journey — research notes, implementation code, infrastructure templates, and reflections — as I progress from building backends to designing distributed systems.

**Not a published book. This is my study guide.**

---

## The Syllabus

Each stage combines research (papers, articles, open-source codebases) with implementation (the Nexus project) and reflection (ADRs, postmortems).

| # | Stage | Focus | What You Build |
|---|-------|-------|----------------|
| 1 | Backend Fundamentals | Auth, APIs, databases | Secure token service + user management |
| 2 | Database Engineering | Schema design, indexing, migrations | Multi-tenant data layer |
| 3 | Cloud Infrastructure | AWS, VPC, networking, IAM | Production-grade deployment |
| 4 | Containerization | Docker, Compose, resource limits | Reproducible environments |
| 5 | Distributed Systems | Microservices, queues, resilience | Event-driven architecture |
| 6 | AI & LLMs | Embeddings, RAG, vector databases | Intelligent feature layer |
| 7 | Search | Elasticsearch, ranking, autocomplete | Full-text search at scale |
| 8 | Observability | Logging, metrics, tracing, alerts | Production visibility |
| 9 | Kubernetes | Orchestration, scaling, deployments | Cloud-native operations |
| 10 | Architecture | ADRs, decision-making, trade-offs | System design maturity |

---

## The Nexus Project

**Nexus** is the unifying project across all 10 stages. It evolves from a simple auth service into a distributed AI platform:

```
Stage 1: Auth Service
  → JWT, OAuth, 2FA, rate limiting
  → PostgreSQL + Redis
  → Node.js REST API

Stage 2: Social Features
  → User profiles, relationships
  → Advanced caching strategies
  → Data migrations

Stage 3: AWS Infrastructure
  → VPC, RDS, S3, ALB
  → Auto Scaling groups
  → IAM and security

Stage 4: Containerization
  → Multi-stage Docker builds
  → Local dev with Compose
  → Resource limits and health checks

Stage 5: Microservices
  → Auth → User → Search → AI services
  → Message queues (RabbitMQ)
  → Circuit breakers and retries

Stage 6: AI Pipeline
  → Text embeddings (OpenAI)
  → RAG (Retrieval-Augmented Generation)
  → Vector database (PGVector)

Stage 7: Search Engine
  → Elasticsearch cluster
  → Hybrid search (keyword + semantic)
  → Autocomplete and ranking

Stage 8: Observability
  → Structured logging (Winston)
  → Prometheus metrics
  → Grafana dashboards
  → Distributed tracing (Jaeger)

Stage 9: Kubernetes
  → Deployments and services
  → Ingress and load balancing
  → HPA (autoscaling), PDB (disruption budgets)
  → GitOps with ArgoCD

Stage 10: Architecture Review
  → ADRs (Architecture Decision Records)
  → C4 diagrams
  → Disaster recovery plan
  → Cost and performance analysis
```

By the end, Nexus is a production-ready, cloud-native AI platform.

---

## Repository Structure

```
.
├── THE-SOFTWARE-ARCHITECT-CODEX.md      # Syllabus notes and concepts
├── examples/                             # My implementations (Stage 1+)
│   ├── auth/                             # Auth service code
│   ├── tests/                            # Unit + integration tests
│   ├── Dockerfile                        # Multi-stage build
│   ├── docker-compose.dev.yml            # Local dev environment
│   ├── package.json
│   └── jest.config.js
├── infra/                                # Infrastructure as Code
│   ├── terraform/                        # AWS modules (Stage 3)
│   ├── kubernetes/                       # K8s manifests (Stage 9)
│   └── monitoring/                       # Prometheus + Grafana (Stage 8)
├── docs/                                 # Learning resources and labs
│   ├── stage-1-testing.md                # Testing exercises
│   ├── stage-2-schema-design.md          # Database design lab
│   ├── stage-3-aws-setup.md              # Infrastructure guide
│   ├── observability-lab.md              # Observability exercises
│   ├── grafana-dashboard-guidance.md     # Dashboard setup
│   └── portfolio-rubric.md               # Self-evaluation checklist
├── doc/adr/                              # Architecture Decision Records
│   ├── template.md
│   ├── 0001-record-architecture-decision.md
│   └── ...
└── .github/workflows/
    └── ci.yml                            # Test + lint pipeline
```

---

## My Learning Approach

1. **Read widely** — Research papers, engineering blogs, open-source projects
2. **Implement deliberately** — Each stage has concrete deliverables (code, tests, infra)
3. **Reflect regularly** — Document decisions (ADRs), failures, and lessons learned
4. **Iterate** — Revisit earlier stages as I learn new patterns
5. **Build in public** — Share progress, invite feedback

---

## How to Use This Repo

**If you're following along:**
- Read `THE-SOFTWARE-ARCHITECT-CODEX.md` for the high-level structure
- Check `examples/` for working implementations
- Follow the labs in `docs/` to practice each stage
- Review `doc/adr/` to see how decisions get documented

**If you're using this as a template for your own learning:**
```bash
git clone https://github.com/Neel654/software-architect-codex.git my-learning-path
cd my-learning-path

# Update the Codex with your own goals
vim THE-SOFTWARE-ARCHITECT-CODEX.md

# Start building Stage 1
cd examples
npm install
npm test
```

---

## Quick Start (Stage 1)

```bash
# Clone
git clone https://github.com/Neel654/software-architect-codex.git
cd software-architect-codex

# Install dependencies
cd examples
npm install

# Run tests
npm test

# Start local dev stack
docker compose -f docker-compose.dev.yml up
```

---

## Progress Tracker

Use the [Portfolio Rubric](docs/portfolio-rubric.md) to self-evaluate at each stage. Track what you've built, what you've learned, and what questions remain.

**Current Focus:** Stage 1 (Backend Fundamentals)

---

## Key Resources

- `THE-SOFTWARE-ARCHITECT-CODEX.md` — Full syllabus with concepts, patterns, trade-offs
- `docs/` — Stage-specific labs, exercises, and guides
- `examples/` — My working implementations (reference, not production)
- `infra/` — Infrastructure templates and configuration
- `doc/adr/` — Architecture decisions and rationale

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

MIT — Feel free to fork and adapt for your own learning.

---

**Last Updated:** 2026-07-07  
**Current Stage:** 1 (Backend Fundamentals)
