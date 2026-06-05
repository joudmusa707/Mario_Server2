import express from "express";
import cors from "cors";
import morgen from "morgan";
import dotenv from "dotenv";
import db from "./db.js";
import authRoutes from "./routes/auth.js";

dotenv.config();
const server = express();

const PORT = process.env.PORT;

server.use(cors());
server.use(express.json());
server.use(morgen("dev"));

//Routes
//auth route
// localhost:3000/api/auth
server.use("/api/auth", authRoutes);
// default route
// localhost:3000/
server.get("/", (req, res) => {
  res.json({ message: "Welcome to Mario API" });
});
// 404 handler route
server.use((req, res) => {
  res.status(404).json({ message: "Route not found" });
});

db.connect().then(() => {
  server.listen(PORT, () => console.log(`Server is running on port ${PORT}`));
});
