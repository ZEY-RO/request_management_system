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
