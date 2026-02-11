# Request Management System API

A Ruby on Rails **API-only** application built to serve JSON data for frontend clients such as React, mobile apps, or other services.

---

## 🚀 Tech Stack

- **Ruby** 3.x
- **Rails** 7.x (API-only)
- **Database**: SQLite (development & test)
- **API Style**: RESTful JSON

---

## 🧰 Prerequisites

Ensure the following are installed on your system:

- **Ruby** (recommended via `rbenv`, `rvm`, or `asdf`)
- **Bundler**
- **Rails**
- **SQLite**
- **Node.js** (required by Rails tooling)

Verify installations:

```bash
ruby -v
rails -v
node -v
```

# 🛠️ Project Setup

## 1. Clone the repository
```
git clone https://github.com/your-username/request_management_system.git
cd request_management_system
```
## 2. Install Ruby dependencies
```
bundle install
```
## 3. Set up the database

Create, migrate, and seed the database:
```
rails db:create
rails db:migrate
rails db:seed
```
## 4. Start the Rails server
```
rails server
```

The API will be available at:
```
http://localhost:3000
```

## Request Management Understanding and Planning

This app exposes a small Request management REST API for creating, listing, and updating requests.

Model: `Request`
- `title` (string, required)
- `description` (text, required)
- `status` (integer enum: `pending`, `approved`, `rejected`) — default `pending`
- `priority` (integer enum: `low`, `medium`, `high`, **required**)
- `created_at` / `updated_at`

Planned API endpoints
- POST /requests
	- Payload: `{ "request": { "title": "...", "description": "...", "status": "pending", "priority": "medium" } }`
	- `priority` is **required**. Allowed values: `low`, `medium`, `high`.
	- Response: `201` `{ "request": { id, title, description, status, priority, created_at, updated_at, user: { email: "..." } } }`
- GET /requests
	- Query params: `status`, `page`, `per_page`
	- Response: `200` `{ "requests": [ { id, title, status, priority, created_at, updated_at, user: { email: "..." } } ], total_count: ... }`
- GET /requests/:id
	- Response: `200` `{ "request": { id, title, description, status, priority, created_at, updated_at, user: { email: "..." } } }` or `404` if not found
- PATCH /requests/:id
	- Payload: partial `request` object (e.g., `{ "request": { "status": "approved" } }` or `{ "request": { "priority": "high" } }`)
	- Response: `200` updated object with user email or `422` validation errors
- DELETE /requests/:id
	- Response: `204` no content

Implementation notes
- Controller: `app/controllers/requests_controller.rb` (JSON responses, strong params, ownership checks)
- Model: `app/models/request.rb` (enums for `status`, belongs to `User`)
- Migration: `db/migrate/*_create_requests.rb` (creates `requests` table with `user_id` FK)
- Routes: `config/routes.rb` — `resources :requests`

Users & Authentication

User model: `User`
- `email` (string, unique, required)
- `encrypted_password` (string, required) — managed by Devise
- `jti` (string, unique) — JWT token identifier for revocation
- `created_at` / `updated_at`

Signup: POST /users
- Payload: `{ "user": { "email": "you@example.com", "password": "secret", "password_confirmation": "secret" } }`
- Response: `201` `{ "user": { id, email } }`

Login: POST /users/sign_in
- Payload: `{ "user": { "email": "you@example.com", "password": "secret" } }`
- Response: `200` `{ "user": { id, email } }`
- Response also includes `Authorization` header with JWT token

Use the JWT token for authenticated requests by setting the `Authorization` header:
```
Authorization: Bearer <jwt_token>
```

Logout: DELETE /users/sign_out
- Requires `Authorization: Bearer <jwt_token>`
- Response: `204` no content

Protected endpoints
- `POST /requests` — create a request (authenticated)
- `PATCH /requests/:id` — update a request (authenticated, user must own the request)
- `DELETE /requests/:id` — delete a request (authenticated, user must own the request)

Public endpoints
- `GET /requests` — list requests (with optional filters: `status`, `title`, `page`, `per_page`)
- `GET /requests/:id` — view a request

Request ownership
- Each request belongs to the user who created it (via `user_id` FK).
- Users can only update or delete their own requests.

Search & Pagination

List requests with filters:
```
GET /requests?status=approved&title=bug&page=1&per_page=25
```

Query params:
- `status` — filter by status (pending, approved, rejected)
- `title` — partial match search on request title
- `page` — page number (default: 1)
- `per_page` — records per page (default: 25, max: 100)
