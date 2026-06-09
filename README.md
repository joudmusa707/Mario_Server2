# Mario Game API Documentation

Welcome to the **Mario Game API**—a robust backend built with Node.js, Express, and PostgreSQL designed to manage user authentication, level progression, coin tracking, and dynamic achievement calculations for a platformer game.

---

# 📱 Project Overview

## What is this App?

This app serves as a centralized gaming backend for a classic Mario-style platformer game. It securely processes user registration and login events, records real-time level progression, updates lifetime collected coin balances, and dynamically runs achievement unlocked checks based on player stats.

## User Requirements

The system is built to satisfy the following functional player requirements:

- **User Authentication:** Players can securely sign up for a new account and log in to save their individual gaming progress.
- **Level Progression Tracking:** The system ensures that players unlock subsequent stages automatically as they win, while locking ahead uncompleted levels.
- **Score & Coin Management:** The app tracks real-time accumulations of total coins earned across gameplay sessions.
- **Dynamic Achievements Unlocking:** The platform evaluates real-time statistics (such as current levels reached, levels cleared, or total coin thresholds met) against static benchmark parameters to unlock player trophies on the fly.
- **Progress Resets:** Players retain full control to wipe their data profiles and start the game experience over from level one.

## Tech Stack

- **Runtime Environment:** Node.js
- **Framework:** Express.js
- **Database:** PostgreSQL
- **Database Driver:** pg
- **Middleware:** Morgan, CORS
- **Configuration:** dotenv

---

# 📂 Project Structure

```text
Mario-Game-API/
├── routes/             # Express Route Modules
│   ├── auth.js         # Signup and login route definitions
│   ├── users.js        # User management, wins, resets, and
│   └── levels.js       # Game level meta configurations
├── .env               # Local environment configurations (Secrets)
├── .env.sample        # Template example for environment
|
├── db.js              # Central PostgreSQL client instantiation
├── mario-schema.sql   # Raw PostgreSQL DDL table schemas
|
├── package.json       # Node.js project manifest and dependency
|
└── server.js          # Server initializer, global middlewares, and lifecycle listeners
```

---

# 🚀 Getting Started

## 1. Prerequisites

Ensure the following software is installed on your machine:

- Node.js (v18+ recommended)
- npm
- PostgreSQL

---

## 2. Database Setup

Create a PostgreSQL database named:

```sql
CREATE DATABASE MarioDB;
```

---

## 3. Environment Configuration

Create a `.env` file in the root directory and add:

```env
PORT=5000
DATABASE_URL=postgresql://postgres:0000@localhost:5432/MarioDB
```

### Environment Variables

| Variable     | Description                                          |
| ------------ | ---------------------------------------------------- |
| PORT         | The port on which the Express server will run        |
| DATABASE_URL | PostgreSQL connection string used by the application |

> **Note:** Update the username, password, host, port, or database name if your PostgreSQL configuration differs from the example above.

## 4. Install Dependencies

```bash
npm install
```

---

## 5. Run the Application

### Production Mode to run the server

```bash
npm i nodemon
```

### Development Mode

```bash
nodemon
```

---

## 6. Verify the Server

If everything is configured correctly, the terminal should display:

```bash
Server running on port 5000
Connected to PostgreSQL
```

The API will be available at:

```text
http://localhost:5000
```

---

# 🗄️ Database Schema Summary

## users Table

Stores player accounts and progression data.

| Column         | Type    | Constraints |
| -------------- | ------- | ----------- |
| id             | SERIAL  | Primary Key |
| fullname       | VARCHAR | NOT NULL    |
| email          | VARCHAR | NOT NULL    |
| password       | VARCHAR | NOT NULL    |
| coincollected  | INTEGER | Default: 0  |
| currentlevel   | INTEGER | Default: 1  |
| completedlevel | INTEGER | Default: 0  |

---

## levels Table

Stores level metadata and configurations.

| Column     | Type    | Constraints   |
| ---------- | ------- | ------------- |
| id         | SERIAL  | Primary Key   |
| name       | VARCHAR | NOT NULL      |
| difficulty | VARCHAR | NOT NULL      |
| stars      | INTEGER | Optional      |
| locked     | BOOLEAN | Default: true |
| colorclass | VARCHAR | Optional      |

---

## achievements Table

Stores achievement definitions and unlock conditions.

| Column            | Type    | Description                                                                   |
| ----------------- | ------- | ----------------------------------------------------------------------------- |
| id                | VARCHAR | Primary Key                                                                   |
| title             | VARCHAR | Achievement title                                                             |
| description       | TEXT    | Achievement description                                                       |
| requirement_type  | VARCHAR | Player metric to evaluate (`completedlevel`, `coincollected`, `currentlevel`) |
| requirement_value | INTEGER | Threshold value required                                                      |

---

# 🛣️ API Endpoints & Routing Guide

## Base URL

```text
http://localhost:5000/api
```

---

# 🔐 Authentication Context (/api/auth)

## 1. Sign Up a New User

Registers a completely new user profile if the target email does not already exist.

**Method:** `POST`

**URL:**

```text
/api/auth/signup
```

**Request Body Required:** Yes

### Request Body Example

```json
{
  "fullname": "John Doe",
  "email": "john@example.com",
  "password": "securepassword123"
}
```

---

## 2. Sign In an Existing User

Validates user credentials and grants access.

**Method:** `POST`

**URL:**

```text
/api/auth/login
```

**Request Body Required:** Yes

### Request Body Example

```json
{
  "email": "john@example.com",
  "password": "securepassword123"
}
```

---

# 👤 User Profiles & Progress Metrics Context (/api/users)

## 3. Get All Users

Retrieves all registered users.

**Method:** `GET`

**URL:**

```text
/api/users
```

### Success Response (200 OK)

```json
[
  {
    "id": 1,
    "fullname": "John Doe",
    "email": "john@example.com",
    "coincollected": 120,
    "currentlevel": 3,
    "completedlevel": 2
  },
  {
    "id": 1,
    "fullname": "John Doe",
    "email": "john@example.com",
    "coincollected": 120,
    "currentlevel": 3,
    "completedlevel": 2
  }
]
```

---

## 4. Get a Specific User

Retrieves a single user by ID.

**Method:** `GET`

**URL:**

```text
/api/users/:id
```

### Success Response (200 OK)

```json
{
  "id": 1,
  "fullname": "John Doe",
  "email": "john@example.com",
  "coincollected": 120,
  "currentlevel": 3,
  "completedlevel": 2
}
```

---

## 5. Update Profile

Updates a player's profile information.

**Method:** `PUT`

**URL:**

```text
/api/users/:id
```

### Request Body Example

```json
{
  "fullname": "John Updated",
  "email": "johnnew@example.com"
}
```

### Success Response (200 OK)

```json
{
  "id": 1,
  "fullname": "John Updated",
  "email": "johnnew@example.com",
  "coincollected": 120,
  "currentlevel": 3,
  "completedlevel": 2
}
```

---

## 6. Level Win Progress Updates

Updates level progression and coin totals when a user completes a level.

**Method:** `PUT`

**URL:**

```text
/api/users/:id/win
```

### Request Body Example

```json
{
  "additionalCoins": 45,
  "currentPlayedLevelId": 3
}
```

### Success Response (200 OK)

```json
{
  "id": 1,
  "fullname": "John Doe",
  "email": "john@example.com",
  "coincollected": 165,
  "currentlevel": 4,
  "completedlevel": 3
}
```

---

## 7. Calculate Achievements Matrix

Returns unlocked and locked achievements.

**Method:** `GET`

**URL:**

```text
/api/users/:id/achievements
```

### Success Response (200 OK)

```json
[
  {
    "id": "ach_1",
    "title": "First Steps",
    "description": "Clear your very first level!",
    "isUnlocked": true
  },
  {
    "id": "ach_coin_500",
    "title": "Treasure Hunter",
    "description": "Amass 500 total coins",
    "isUnlocked": false
  }
]
```

---

## 8. Reset User Progress

Resets progression data while preserving the account.

**Method:** `PUT`

**URL:**

```text
/api/users/:id/progress
```

### Success Response (200 OK)

```json
{
  "id": 1,
  "fullname": "John Doe",
  "email": "john@example.com",
  "coincollected": 0,
  "currentlevel": 1,
  "completedlevel": 0
}
```

---

## 9. Delete a User

Permanently removes a user account.

**Method:** `DELETE`

**URL:**

```text
/api/users/:id
```

### Success Response (200 OK)

```json
{
  "message": "User deleted",
  "user": {
    "id": 1,
    "fullname": "John Doe",
    "email": "john@example.com"
  }
}
```

---

# 🎮 Game Levels Context (/api/levels)

## 10. Get All Levels

Returns all available game levels.

**Method:** `GET`

**URL:**

```text
/api/levels
```

### Success Response (200 OK)

```json
[
  {
    "id": 1,
    "name": "World 1-1",
    "difficulty": "Easy",
    "stars": 3,
    "locked": false,
    "colorclass": "bg-green"
  }
]
```

---

## 11. Get a Specific Level

Returns a specific level by ID.

**Method:** `GET`

**URL:**

```text
/api/levels/:id
```

### Success Response (200 OK)

```json
{
  "id": 1,
  "name": "World 1-1",
  "difficulty": "Easy",
  "stars": 3,
  "locked": false,
  "colorclass": "bg-green"
}
```

---

# 🛡️ Error Protocol Reference

Standardized JSON formats are returned when errors occur.

## 400 Bad Request

Returned for invalid credentials, malformed requests, or duplicate registrations.

```json
{
  "error": "Invalid credentials"
}
```

---

## 404 Not Found

Returned when a resource does not exist.

```json
{
  "error": "User not found"
}
```

---

## 500 Internal Server Error

Returned for unexpected server or database failures.

```json
{
  "error": "Internal server error"
}
```

---

# 📌 Additional Notes

- All responses are returned in JSON format.
- Player progress is maintained independently for every registered account.
- Level progression automatically unlocks the next available stage after successful completion.
- Achievement calculations are dynamic and evaluated in real time.
- Progress resets preserve account credentials while resetting gameplay statistics.
- PostgreSQL serves as the persistent storage layer for users, levels, and achievements.
- Environment variables should never be committed to source control repositories.
