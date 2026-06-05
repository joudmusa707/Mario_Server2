import express from "express";
import pgclient from "../db.js";

const router = express.Router();

// Get all users
// GET /api/users

router.get("/", async (req, res) => {
  try {
    const result = await pgclient.query("SELECT * FROM users");
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: "Internal server error" });
  }
});

// Get a specific user
// GET /api/users/:id

router.get("/:id", async (req, res) => {
  try {
    const result = await pgclient.query("SELECT * FROM users WHERE id = $1", [
      req.params.id,
    ]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "User not found" });
    }
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: "Internal server error" });
  }
});

// Update a user
// PUT /api/users/:id

router.put("/:id", async (req, res) => {
  const { name, age } = req.body;
  try {
    const result = await pgclient.query(
      "UPDATE users SET name = $1, age = $2 WHERE id = $3 RETURNING *",
      [name, age, req.params.id],
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "User not found" });
    }
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: "Internal server error" });
  }
});

// Delete a user
// DELETE /api/users/:id

router.delete("/:id", async (req, res) => {
  try {
    const result = await pgclient.query(
      "DELETE FROM users WHERE id = $1 RETURNING *",
      [req.params.id],
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "User not found" });
    }
    res.json({ message: "User deleted", user: result.rows[0] });
  } catch (err) {
    res.status(500).json({ error: "Internal server error" });
  }
});

export default router;
