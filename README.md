# Shop API

A RESTful API for shop management built with Ruby on Rails 7.2. Provides JWT-based authentication with access/refresh token rotation and API key authorization.

## Tech Stack

- **Ruby** 3.3.6
- **Rails** 7.2.3 (API-only mode)
- **PostgreSQL**
- **JWT** for authentication
- **bcrypt** for password hashing
- **Puma** web server
- **Kamal** for deployment
- **Docker** for containerization

## Getting Started

### Prerequisites

- Ruby 3.3.6
- PostgreSQL
- Bundler

### Setup

```bash
# Install dependencies
bundle install

# Create and migrate the database
bin/rails db:create db:migrate

# Seed the database (optional)
bin/rails db:seed

# Start the server
bin/rails server
```

### Environment Variables

Create a `.env` file in the project root with the following variables:

```env
DATABASE_URL=postgres://user:password@localhost:5432/shop_api_development
```

### Docker

```bash
# Build the image
docker build -t shop_api .

# Run the container
docker run -d -p 80:80 -e RAILS_MASTER_KEY=<value from config/master.key> --name shop_api shop_api
```

## Authentication

All endpoints require an **API key** passed via the `X-API-KEY` header. The API key must have the appropriate permissions (`read`, `write`, or `admin`).

Authenticated endpoints additionally require:

| Header          | Description                              |
|-----------------|------------------------------------------|
| `X-API-KEY`     | API key with required permissions        |
| `X-CLIENT-ID`   | Shop ID (returned on register/login)     |
| `Authorization` | `Bearer <access_token>`                  |

### Token Flow

1. **Register** or **Login** to receive an `access_token` (2-day expiry) and `refresh_token` (7-day expiry)
2. Use the `access_token` in the `Authorization` header for authenticated requests
3. When the access token expires, use the **Refresh Token** endpoint to get new tokens
4. Each refresh rotates both tokens and tracks used refresh tokens to detect token reuse (theft protection)

## API Endpoints

Base URL: `/api/v1/shops`

### Register

Create a new shop account.

```
POST /api/v1/shops/register
```

**Headers:**
```
X-API-KEY: <api_key>
```

**Body:**
```json
{
  "shop": {
    "name": "My Shop",
    "email": "shop@example.com",
    "password": "password123"
  }
}
```

**Response (201 Created):**
```json
{
  "message": "Shop created successfully",
  "metadata": {
    "shop": {
      "id": 1,
      "name": "My Shop",
      "email": "shop@example.com"
    },
    "token": {
      "access_token": "eyJhbGciOi...",
      "refresh_token": "eyJhbGciOi..."
    }
  }
}
```

### Login

Authenticate an existing shop.

```
POST /api/v1/shops/login
```

**Headers:**
```
X-API-KEY: <api_key>
```

**Body:**
```json
{
  "email": "shop@example.com",
  "password": "password123"
}
```

**Response (200 OK):**
```json
{
  "message": "Shop logged in successfully",
  "metadata": {
    "shop": {
      "id": 1,
      "name": "My Shop",
      "email": "shop@example.com"
    },
    "token": {
      "access_token": "eyJhbGciOi...",
      "refresh_token": "eyJhbGciOi..."
    }
  }
}
```

### Refresh Token

Get new access and refresh tokens using a valid refresh token.

```
POST /api/v1/shops/refresh_token
```

**Headers:**
```
X-API-KEY: <api_key>
X-CLIENT-ID: <shop_id>
```

**Body:**
```json
{
  "refresh_token": "eyJhbGciOi..."
}
```

**Response (200 OK):**
```json
{
  "message": "Token refreshed successfully",
  "metadata": {
    "token": {
      "access_token": "eyJhbGciOi...",
      "refresh_token": "eyJhbGciOi..."
    }
  }
}
```

> **Note:** Each refresh token can only be used once. Reusing a previously used refresh token will revoke all tokens for the shop (theft detection).

### Logout

Revoke all tokens for the authenticated shop.

```
POST /api/v1/shops/logout
```

**Headers:**
```
X-API-KEY: <api_key>
X-CLIENT-ID: <shop_id>
Authorization: Bearer <access_token>
```

**Response (200 OK):**
```json
{
  "message": "Shop logged out successfully",
  "metadata": {
    "acknowledged": true,
    "deletedCount": 1
  }
}
```

## Error Responses

All errors follow a consistent format:

```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable error message"
  }
}
```

| Code               | HTTP Status | Description                          |
|--------------------|-------------|--------------------------------------|
| `BAD_REQUEST`      | 400         | Invalid request parameters           |
| `UNAUTHORIZED`     | 401         | Missing or invalid authentication    |
| `INVALID_TOKEN`    | 401         | Invalid or expired JWT token         |
| `FORBIDDEN`        | 403         | Missing API key or insufficient permissions |
| `NOT_FOUND`        | 404         | Resource not found                   |
| `VALIDATION_ERROR` | 422         | Record validation failed             |

## Project Structure

```
app/
  controllers/
    api/v1/
      shops_controller.rb    # Shop registration, login, logout, refresh token
    application_controller.rb # API key auth, permissions, error handling
  errors/                    # Custom error classes (ApiError, UnauthorizedError, etc.)
  models/
    shop.rb                  # Shop model with bcrypt password and roles
    token.rb                 # Token storage (public/private keys, refresh token)
    api_key.rb               # API key with permissions (read, write, admin)
  serializers/               # ActiveModelSerializers for JSON responses
  services/
    authenticate_service.rb  # Access token verification middleware
    refresh_token_service.rb # Refresh token validation and rotation
    shop_authenticator.rb    # Login logic
    shop_creator.rb          # Registration logic
    token_service.rb         # JWT token issuance and storage
lib/
  json_web_token.rb          # JWT encode/decode wrapper
```

## Database Schema

### shops

| Column          | Type    | Notes                          |
|-----------------|---------|--------------------------------|
| name            | string  | required                       |
| email           | string  | required, unique               |
| password_digest | string  | bcrypt hash                    |
| status          | string  | default: `"inactive"`          |
| verify          | boolean | default: `false`               |
| roles           | text[]  | `shop`, `writer`, `editor`, `admin` |

### tokens

| Column              | Type    | Notes                            |
|---------------------|---------|----------------------------------|
| user_id             | integer | references shop                  |
| public_key          | string  | used to sign access tokens       |
| private_key         | string  | used to sign refresh tokens      |
| refresh_token       | string  | current valid refresh token      |
| refresh_tokens_used | text[]  | previously used refresh tokens   |

### api_keys

| Column      | Type     | Notes                              |
|-------------|----------|------------------------------------|
| key         | string   | required, unique                   |
| status      | boolean  | default: `true`                    |
| permissions | string[] | `read`, `write`, `admin`           |

## Linting

```bash
bin/rubocop
```

## Security Scanning

```bash
# Static analysis
bin/brakeman --no-pager

# Gem vulnerability audit
bin/bundler-audit
```
