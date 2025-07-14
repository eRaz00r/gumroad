# Agents.md - AI Agent Guide for Gumroad

This document provides comprehensive guidance for AI agents working with the Gumroad codebase. Gumroad is an e-commerce platform that enables creators to sell products directly to consumers.

## Project Overview

**Purpose**: E-commerce platform for digital creators to sell products (digital goods, subscriptions, physical products)
**Architecture**: Ruby on Rails monolith with React frontend components
**Primary Language**: Ruby (backend), TypeScript/JavaScript (frontend)
**Database**: MySQL with Redis for caching and background jobs
**Key Features**: Product sales, subscriptions, payment processing, creator tools, analytics

## Technology Stack

### Backend
- **Ruby**: Latest version (see `.ruby-version`)
- **Rails**: 7.1.3.4
- **Database**: MySQL 8.0.x
- **Background Jobs**: Sidekiq Pro 7.2 with Redis
- **Search**: Elasticsearch 7.11.2
- **Authentication**: Devise with OAuth2 (Doorkeeper)
- **Payment Processing**: Stripe, PayPal, Braintree
- **File Storage**: AWS S3 with CDN

### Frontend
- **Node.js**: ~20.17.0
- **React**: 18.1.0
- **TypeScript**: Latest
- **Build Tool**: Webpack with react-on-rails
- **CSS Framework**: Tailwind CSS
- **State Management**: React hooks and context

### Development Tools
- **Testing**: RSpec, Capybara, FactoryBot
- **Linting**: RuboCop, ESLint
- **Code Quality**: Prettier, TypeScript strict mode
- **Deployment**: Docker, AWS

## Project Structure

```
gumroad/
├── app/
│   ├── controllers/          # HTTP request handlers
│   │   ├── api/             # API endpoints (v2, mobile, internal)
│   │   ├── concerns/        # Controller mixins
│   │   └── [domain]/        # Domain-specific controllers
│   ├── models/              # Domain models and business logic
│   │   ├── concerns/        # Model mixins
│   │   └── [domain]/        # Domain-specific models
│   ├── services/            # Service objects for business logic
│   │   └── onetime/         # One-time scripts and migrations
│   ├── sidekiq/             # Background job workers
│   ├── javascript/          # Frontend TypeScript/React code
│   │   ├── components/      # React components
│   │   ├── utils/           # Utility functions
│   │   └── packs/           # Webpack entry points
│   ├── views/               # Rails view templates
│   └── business/            # Domain-specific business logic
├── config/                  # Configuration files
├── db/                      # Database migrations and seeds
├── spec/                    # Test files
└── lib/                     # Shared utilities and extensions
```

## Core Domain Models

### Primary Entities
- **User**: Represents both buyers and sellers (creators)
- **Link** (Product): Digital or physical products for sale
- **Purchase**: Transaction records for product sales
- **Subscription**: Recurring billing for products
- **Payment**: Payout records to creators
- **Balance**: Creator earnings tracking
- **Workflow**: Automated email sequences
- **Installment**: Email content in workflows

### Key Relationships
- User has_many :products (Links)
- User has_many :purchases (as buyer)
- User has_many :sales (as seller)
- Product belongs_to :user (seller)
- Purchase belongs_to :link (product)
- Purchase belongs_to :purchaser (User)

## Coding Conventions

### General Guidelines
- Use latest versions of Ruby, Rails, TypeScript, and React
- Sentence case for UI text (not title case)
- No comments in production code
- Don't apologize for errors, fix them
- Use `product` instead of `link` in new code
- Use `buyer` and `seller` instead of `customer` and `creator`
- Use `request` instead of `$.ajax` for HTTP requests

### Ruby/Rails Specific
- Use `frozen_string_literal: true` in all Ruby files
- Prefer concerns over modules in `app/modules/`
- Use feature flags for new features
- Service objects for complex business logic
- Background jobs end with "Job" suffix
- Use nano IDs for external/public IDs

### JavaScript/TypeScript Specific
- Use `import debounce from "lodash/debounce"` (not destructured)
- Prefer functional components with hooks
- Use TypeScript for all new code
- Follow existing code style in each file
- Use meaningful variable and function names

### Database and Background Jobs
- Use Sidekiq queues in priority order: `critical`, `default`, `low`, `mongo`
- Avoid ActiveRecord callbacks for backfilling operations
- Use `lock: :until_executed` for job deduplication
- Prefer one-time scripts for data migrations

## Testing Protocols

### Framework and Structure
- **Primary**: RSpec for Ruby tests
- **Feature Tests**: Capybara for browser automation
- **Factories**: FactoryBot for test data
- **Mocking**: Built-in RSpec mocking
- **Coverage**: Comprehensive test coverage expected

### Testing Conventions
- Don't start test names with "should"
- Use descriptive test names explaining behavior
- Use `@example.com` for test emails
- Use `example.com`, `example.org`, `example.net` for test domains
- Avoid `unless` in test conditions
- Use `SidekiqWorkerName.jobs.size` for job assertions

### Running Tests
```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/path/to/test_spec.rb

# Run with coverage
bundle exec rspec --coverage

# Run JavaScript tests
npm test
```

## API Structure

### API Versions
- **v2**: Main public API with OAuth2
- **Mobile**: Mobile app specific endpoints
- **Internal**: Internal tool endpoints

### Authentication
- **Public API**: OAuth2 with scopes
- **Internal**: Token-based authentication
- **Mobile**: Special mobile tokens

### Response Format
```json
{
  "success": true,
  "data": {},
  "message": "Optional message"
}
```

## Development Workflow

### Setup Commands
```bash
# Install dependencies
bundle install
npm install

# Database setup
rails db:prepare

# Start development server
bin/dev

# Run linting
npm run lint
bundle exec rubocop
```

### Development Users
- `seller@gumroad.com` (password: `password`) - Primary test user
- `seller+admin@gumroad.com` - Admin user
- Various role-based test users available

### Feature Development
1. Create feature branch
2. Implement with tests
3. Run full test suite
4. Submit PR with descriptive title
5. Code review and merge

## Background Jobs and Queues

### Queue Priority (highest to lowest)
1. **critical**: Receipt/purchase emails only
2. **default**: Time-sensitive jobs
3. **low**: General background jobs (recommended default)
4. **mongo**: Legacy queue for one-time scripts

### Common Job Patterns
- Email sending (receipts, notifications)
- Payment processing
- Data synchronization
- Analytics updates
- File processing

## Architecture Patterns

### Service Objects
- Located in `app/services/`
- Handle complex business logic
- Return success/error responses
- Used by controllers and background jobs

### Concerns
- Shared functionality across models/controllers
- Located in `app/models/concerns/` and `app/controllers/concerns/`
- Include common behaviors and validations

### State Machines
- Used for model state transitions
- Common in Purchase, Payment, Subscription models
- Handle complex business state logic

## Performance Considerations

### Database
- Use read replicas for heavy queries
- Elasticsearch for search functionality
- Redis for caching and sessions
- Background jobs for heavy operations

### Frontend
- Server-side rendering with React
- Code splitting and lazy loading
- Image optimization and CDN usage
- Performance monitoring

## Security Guidelines

### Authentication and Authorization
- OAuth2 for API access
- Pundit for authorization policies
- Two-factor authentication support
- CSRF protection enabled

### Data Protection
- Encrypted sensitive data
- PCI compliance for payments
- GDPR compliance features
- Regular security audits

## Deployment and Infrastructure

### Development Environment
- Docker for service dependencies
- Local Rails server for development
- Hot reloading for frontend changes

### Production Deployment
- Automated deployments via CI/CD
- Blue-green deployment strategy
- Health checks and monitoring
- Rollback capabilities

## Common Pitfalls to Avoid

1. **Don't** create methods ending in `_path` or `_url` (conflicts with Rails helpers)
2. **Don't** use `to_not have_enqueued_sidekiq_job` in tests (prone to false positives)
3. **Don't** perform backfilling in ActiveRecord callbacks
4. **Don't** use `unless` statements (prefer positive conditions)
5. **Don't** create files in `app/modules/` (use concerns instead)

## Key Business Logic Areas

### Payment Processing
- Stripe integration for card payments
- PayPal for alternative payments
- Subscription billing and management
- Refund and dispute handling

### Product Management
- Digital and physical product support
- Variant and pricing management
- Inventory tracking
- Preview and download systems

### Creator Tools
- Analytics and reporting
- Email marketing workflows
- Affiliate program management
- Custom domain support

## Monitoring and Observability

### Logging
- Structured logging with Rails logger
- Error tracking with Bugsnag
- Performance monitoring
- Custom metrics collection

### Health Checks
- Database connectivity
- Redis availability
- External service status
- Background job queue health

## External Integrations

### Payment Providers
- Stripe (primary)
- PayPal
- Braintree

### Communication
- SendGrid for transactional emails
- Twilio for SMS
- Slack for notifications

### Analytics
- Google Analytics
- Custom analytics tracking
- Real-time metrics

This guide should help AI agents understand the Gumroad codebase structure, follow established conventions, and contribute effectively to the project. Always refer to the existing codebase for the most current patterns and implementations.
