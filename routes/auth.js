import express from "express";
import db from "../db.js";

const router = express.Router();

// Sign up a new user
// POST /api/auth/signup

// body => {fullname, email, password}
router.post("/signup", async (req, res) => {
  const { fullname, email, password } = req.body;
  try {
    const exists = await db.query("SELECT * FROM users WHERE email = $1", [
      email,
    ]);
    if (exists.rows.length > 0) {
      return res.status(400).json({ message: "User already exists" });
    }
    const result = await db.query(
      "INSERT INTO users (fullname, email, password) VALUES ($1, $2, $3) RETURNING *",
      [fullname, email, password],
    );
    res
      .status(201)
      .json({ message: "User created successfully", user: result.rows[0] });
  } catch (error) {
    console.error("Error signing up user:", error);
    res.status(500).json({ message: "Internal server error" });
  }
});

// Sign in an existing user
// POST /api/auth/login
// body => {email, password}
router.post("/login", async (req, res) => {
  const { email, password } = req.body;
  try {
    const result = await db.query(
      "SELECT * FROM users WHERE email = $1 AND password = $2",
      [email, password],
    );
    if (result.rows.length === 0) {
      return res.status(400).json({ message: "Invalid email or password" });
    }
    res.json({ user: result.rows[0], message: "Login successful" });
  } catch (error) {
    console.error("Error signing in user:", error);
    res.status(500).json({ message: "Internal server error" });
  }
});

export default router;
