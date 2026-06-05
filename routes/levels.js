import express from "express";
import pgclient from "../db.js";

const router = express.Router();

// Get all levels
// GET /api/levels

router.get("/", async (req, res) => {
  try {
    const result = await pgclient.query("SELECT * FROM levels");
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: "Internal server error" });
  }
});

// Get a specific level
// GET /api/levels/:id

router.get("/:id", async (req, res) => {
  try {
    const result = await pgclient.query("SELECT * FROM levels WHERE id = $1", [
      req.params.id,
    ]);
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "Level not found" });
    }
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: "Internal server error" });
  }
});

export default router;
