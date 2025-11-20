# Project Specifications - Example Template

**🎯 Purpose**: This is an EXAMPLE specification document to demonstrate what you should create for your own projects.

**📋 Note**: This file stays in the template repository and is NOT copied to new projects. Use it as a guide to create your own specifications.

---

## **Why Project Specifications Matter**

When working with Claude Code (or any AI assistant), clear specifications help:
- ✅ **Maintain consistency** across development sessions
- ✅ **Onboard AI assistants** quickly with project context
- ✅ **Prevent scope creep** by documenting requirements clearly
- ✅ **Enable better decisions** by having requirements readily accessible
- ✅ **Track changes** to requirements over time

---

## **What to Include in Your Specifications**

Place specification documents in your project's `specifications/` directory:

```
your-project/
├── specifications/
│   ├── REQUIREMENTS.md              # High-level project requirements
│   ├── ARCHITECTURE.md              # System architecture and design decisions
│   ├── API_SPECIFICATION.md         # API endpoints, contracts, schemas
│   ├── DATA_MODELS.md               # Database schemas, data structures
│   ├── USER_STORIES.md              # User stories and acceptance criteria
│   └── TECHNICAL_CONSTRAINTS.md     # Performance, security, compliance requirements
```

---

## **Example: REQUIREMENTS.md**

```markdown
# Project Requirements

## Overview
Brief description of what the project does and why it exists.

## Functional Requirements

### FR-1: User Authentication
- Users must be able to register with email/password
- Users must be able to log in with credentials
- Sessions must expire after 24 hours of inactivity
- Passwords must meet complexity requirements (8+ chars, mixed case, numbers)

### FR-2: Data Management
- Users can create, read, update, delete their own records
- Admin users can view all records
- All operations must be logged for audit trail

## Non-Functional Requirements

### Performance
- API response time < 200ms for 95th percentile
- Support 1000 concurrent users
- Database queries optimized (no N+1 queries)

### Security
- All API endpoints require authentication
- Sensitive data encrypted at rest
- HTTPS only for all communications
- Input validation on all user-supplied data

### Scalability
- Horizontally scalable architecture
- Stateless API servers
- Database read replicas for scaling reads
```

---

## **Example: ARCHITECTURE.md**

```markdown
# System Architecture

## Technology Stack
- **Backend**: Python 3.11+ with FastAPI
- **Database**: PostgreSQL 15+
- **Cache**: Redis 7+
- **Frontend**: React 18+ with TypeScript
- **Deployment**: Docker containers on AWS ECS

## Architecture Diagram
```
┌─────────────┐
│   Browser   │
└──────┬──────┘
       │ HTTPS
       ▼
┌─────────────┐      ┌──────────────┐
│  API Server │─────▶│  PostgreSQL  │
│  (FastAPI)  │      │   Database   │
└──────┬──────┘      └──────────────┘
       │
       ▼
┌─────────────┐
│    Redis    │
│    Cache    │
└─────────────┘
```

## Component Responsibilities

### API Server
- Request validation and authentication
- Business logic execution
- Response formatting
- Session management

### Database
- Persistent data storage
- Transactional integrity
- Data relationships enforcement

### Cache
- Session storage
- Frequently accessed data
- Rate limiting counters

## Key Design Decisions

### Why FastAPI?
- Automatic OpenAPI documentation
- Built-in validation with Pydantic
- Async support for high concurrency
- Type hints for better IDE support

### Why PostgreSQL?
- ACID compliance required
- Complex queries with relationships
- JSON support for flexible data
- Proven reliability at scale
```

---

## **Example: API_SPECIFICATION.md**

```markdown
# API Specification

## Authentication

All endpoints (except `/auth/register` and `/auth/login`) require:
- Header: `Authorization: Bearer <jwt_token>`

## Endpoints

### POST /auth/register
Create a new user account.

**Request:**
```json
{
  "email": "user@example.com",
  "password": "SecurePass123",
  "username": "johndoe"
}
```

**Response (201):**
```json
{
  "user_id": "uuid-here",
  "email": "user@example.com",
  "username": "johndoe",
  "created_at": "2024-10-14T12:00:00Z"
}
```

**Errors:**
- 400: Invalid email format or weak password
- 409: Email already registered

### GET /users/{user_id}
Retrieve user profile.

**Response (200):**
```json
{
  "user_id": "uuid-here",
  "email": "user@example.com",
  "username": "johndoe",
  "created_at": "2024-10-14T12:00:00Z",
  "last_login": "2024-10-15T08:30:00Z"
}
```

**Errors:**
- 401: Not authenticated
- 403: Cannot access other user's profile
- 404: User not found
```

---

## **Example: DATA_MODELS.md**

```markdown
# Data Models

## User Model

### Database Schema (PostgreSQL)
```sql
CREATE TABLE users (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    last_login TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    role VARCHAR(20) DEFAULT 'user'
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
```

### Python Model (Pydantic)
```python
from pydantic import BaseModel, EmailStr
from datetime import datetime
from uuid import UUID

class User(BaseModel):
    user_id: UUID
    email: EmailStr
    username: str
    created_at: datetime
    updated_at: datetime
    last_login: Optional[datetime]
    is_active: bool = True
    role: str = "user"

    class Config:
        orm_mode = True
```

## Session Model

### Redis Schema
```
Key: session:{session_id}
Value (JSON):
{
  "user_id": "uuid-here",
  "created_at": 1697284800,
  "last_accessed": 1697371200
}
TTL: 86400 seconds (24 hours)
```
```

---

## **Example: USER_STORIES.md**

```markdown
# User Stories

## Epic: User Authentication

### Story 1: User Registration
**As a** new user
**I want to** create an account with my email
**So that** I can access the application

**Acceptance Criteria:**
- [ ] Registration form validates email format
- [ ] Password must meet complexity requirements
- [ ] Duplicate email shows clear error message
- [ ] Successful registration redirects to login
- [ ] Confirmation email sent to user

**Technical Notes:**
- Use bcrypt for password hashing (cost factor: 12)
- Email validation on both client and server
- Store user in PostgreSQL users table

---

### Story 2: User Login
**As a** registered user
**I want to** log in with my credentials
**So that** I can access my account

**Acceptance Criteria:**
- [ ] Login form accepts email and password
- [ ] Invalid credentials show generic error (no username enumeration)
- [ ] Successful login creates session and redirects to dashboard
- [ ] Session persists across page refreshes
- [ ] "Remember me" option extends session to 30 days

**Technical Notes:**
- Use JWT tokens stored in httpOnly cookies
- Rate limit: 5 failed attempts per 15 minutes per IP
- Log all login attempts for security audit
```

---

## **Example: TECHNICAL_CONSTRAINTS.md**

```markdown
# Technical Constraints

## Performance Requirements

### Response Times
- API endpoints: < 200ms (p95)
- Database queries: < 50ms (p95)
- Page load time: < 2s (p95)

### Throughput
- Minimum: 1000 requests/second
- Peak capacity: 5000 requests/second
- Database connections: 100 max per instance

## Security Requirements

### Authentication & Authorization
- JWT tokens with 1-hour expiration
- Refresh tokens with 30-day expiration
- RBAC (Role-Based Access Control) for all resources
- Multi-factor authentication for admin users

### Data Protection
- All PII encrypted at rest (AES-256)
- TLS 1.3 for data in transit
- Password hashing with bcrypt (cost: 12)
- API keys rotated every 90 days

### Compliance
- GDPR compliant (EU users)
- CCPA compliant (California users)
- SOC 2 Type II compliance required
- PCI DSS for payment processing

## Scalability Constraints

### Infrastructure
- Kubernetes cluster (min 3 nodes)
- Auto-scaling: 2-10 API server pods
- Database read replicas: 2 minimum
- Redis cluster: 3-node minimum

### Code Requirements
- Stateless application servers
- No server-side session storage
- All background jobs via message queue
- Database migrations must be reversible

## Technology Constraints

### Approved Technologies
- Python 3.11+ (backend)
- PostgreSQL 15+ (primary database)
- Redis 7+ (cache/sessions)
- React 18+ (frontend)
- Docker & Kubernetes (deployment)

### Forbidden Technologies
- No MongoDB (data integrity requirements)
- No client-side sensitive data storage
- No synchronous long-running operations in API
- No direct database access from frontend

## Operational Constraints

### Monitoring
- APM metrics collection (response times, errors)
- Log aggregation (centralized logging)
- Uptime monitoring (99.9% SLA)
- Alerting for critical errors

### Deployment
- Zero-downtime deployments
- Blue-green deployment strategy
- Automated rollback on health check failure
- Database migrations in separate deployment step

### Backup & Recovery
- Database backups every 6 hours
- 30-day backup retention
- Point-in-time recovery capability
- Disaster recovery RTO: 4 hours, RPO: 1 hour
```

---

## **Tips for Writing Effective Specifications**

### For Claude Code Sessions

1. **Reference specifications in SESSION_STARTUP.md**
   ```markdown
   Before implementing features:
   1. Read relevant specification documents from specifications/
   2. Follow CODING_GUIDELINES.md
   3. Validate implementation against acceptance criteria
   ```

2. **Update CLAUDE.md to point to specifications**
   ```markdown
   ## Project Specifications
   All requirements are documented in the `specifications/` directory.
   Always review relevant specs before implementing features.
   ```

3. **Keep specifications current**
   - Update specs when requirements change
   - Document decisions in ARCHITECTURE.md
   - Link code to requirements (e.g., `# Implements FR-1: User Authentication`)

4. **Use specifications in prompts**
   ```
   "Implement the user registration endpoint following the API specification
   in specifications/API_SPECIFICATION.md and ensure it meets the requirements
   in specifications/REQUIREMENTS.md section FR-1."
   ```

### Best Practices

- ✅ **Be specific**: Vague requirements lead to implementation uncertainty
- ✅ **Use examples**: Show concrete examples of inputs/outputs
- ✅ **Version control**: Track specification changes in git
- ✅ **Link to code**: Reference spec sections in code comments
- ✅ **Review regularly**: Update specs as project evolves
- ✅ **Keep accessible**: Specifications should be easy to find and read

---

## **Getting Started with Your Project**

1. **Create your specifications directory:**
   ```bash
   mkdir -p specifications
   ```

2. **Start with essential documents:**
   - `REQUIREMENTS.md` - What the project must do
   - `ARCHITECTURE.md` - How it's built
   - Add others as needed for your project complexity

3. **Reference in your CLAUDE.md:**
   ```markdown
   ## Project Specifications
   See `specifications/` directory for:
   - Requirements and acceptance criteria
   - Architecture decisions and constraints
   - API contracts and data models
   ```

4. **Update SESSION_STARTUP.md:**
   ```markdown
   **Claude, please read and acknowledge:**
   1. CODING_GUIDELINES.md - Universal architecture principles
   2. DEVELOPER_GUIDELINES.md - Development workflow
   3. specifications/ - Project-specific requirements
   ```

---

**Remember**: Good specifications save time in the long run by reducing ambiguity and enabling better AI assistance!
