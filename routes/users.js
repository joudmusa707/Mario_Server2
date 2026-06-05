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

// Get a user's calculated achievements matrix
// GET /api/users/:id/achievements

router.get("/:id/achievements", async (req, res) => {
  try {
    const userResult = await pgclient.query(
      "SELECT currentlevel, coincollected, completedlevel FROM users WHERE id = $1",
      [req.params.id],
    );
    if (userResult.rows.length === 0) {
      return res.status(404).json({ message: "User not found" });
    }
    const user = userResult.rows[0];

    const achievementsResult = await pgclient.query(
      "SELECT * FROM achievements ORDER BY requirement_value ASC",
    );
    const staticAchievements = achievementsResult.rows;

    const dynamicAchievements = staticAchievements.map((ach) => {
      let currentProgressValue = 0;

      // Safe fallback protections handling potential null values
      if (ach.requirement_type === "completedlevel")
        currentProgressValue = user.completedlevel || 0;
      if (ach.requirement_type === "coincollected")
        currentProgressValue = user.coincollected || 0;
      if (ach.requirement_type === "currentlevel")
        currentProgressValue = user.currentlevel || 1;

      return {
        id: ach.id,
        title: ach.title,
        description: ach.description,
        isUnlocked:
          currentProgressValue >= parseInt(ach.requirement_value || 0),
      };
    });

    res.json(dynamicAchievements);
  } catch (err) {
    console.error("Achievements processing error:", err); // Keep this to trace unexpected database hiccups!
    res.status(500).json({ error: "Internal server error" });
  }
});

// Update a user
// PUT /api/users/:id

router.put("/:id", async (req, res) => {
  const { fullname, email } = req.body;
  try {
    const result = await pgclient.query(
      "UPDATE users SET fullname = $1, email = $2 WHERE id = $3 RETURNING *",
      [fullname, email, req.params.id],
    );
    if (result.rows.length === 0) {
      return res.status(404).json({ message: "User not found" });
    }
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: "Internal server error" });
  }
});

// reset user progress
// PUT /api/users/:id/progress

router.put("/:id/progress", async (req, res) => {
  const { resetProgress } = req.body;
  try {
    const result = await pgclient.query(
      "UPDATE users SET coincollected = 0, currentlevel = 1, completedlevel = 0 WHERE id = $1 RETURNING *",
      [req.params.id],
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "User not found" });
    }
    res.json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: "Internal server error" });
  }
});

// Update user level progress and add newly earned coins
// PUT /api/users/:id/win
router.put("/:id/win", async (req, res) => {
  const { additionalCoins, currentPlayedLevelId } = req.body;
  const userId = req.params.id;

  try {
    const result = await pgclient.query(
      `UPDATE users 
       SET 
         coincollected = coincollected + $1,
         completedlevel = GREATEST(completedlevel, $2),
         currentlevel = GREATEST(currentlevel, $2 + 1)
       WHERE id = $3 
       RETURNING *`,
      [parseInt(additionalCoins || 0), parseInt(currentPlayedLevelId), userId],
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "User not found" });
    }

    res.json(result.rows[0]);
  } catch (err) {
    console.error("Database error in win path:", err);
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
