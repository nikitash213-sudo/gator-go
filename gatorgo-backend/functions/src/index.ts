import express from "express";
import cors from "cors";
import { onRequest } from "firebase-functions/v2/https";
import { resourcesRouter } from "./routes/resources.js";
import { landmarksRouter } from "./routes/landmarks.js";
import { aiRouter } from "./routes/ai.js";
import { usersRouter } from "./routes/users.js";
import { config } from "./config.js";

const app = express();
app.use(cors({ origin: true }));
app.use(express.json({ limit: "256kb" }));

app.get("/health", (_req, res) => res.json({ ok: true, service: "gatorgo-api" }));
app.use("/resources", resourcesRouter);
app.use("/landmarks", landmarksRouter);
app.use("/ai", aiRouter);
app.use("/users", usersRouter);
app.use((_req, res) => res.status(404).json({ error: "Not found" }));

export const api = onRequest({ region: config.region, timeoutSeconds: 60, memory: "512MiB" }, app);
