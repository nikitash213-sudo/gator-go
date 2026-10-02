import { Router } from "express";
import { z } from "zod";
import { db } from "../firebase.js";
import { requireAuth } from "../middleware/auth.js";

export const usersRouter = Router();
usersRouter.use(requireAuth);

usersRouter.get("/me", async (req, res) => {
  const doc = await db.collection("users").doc(req.user!.uid).get();
  res.json({ id: req.user!.uid, ...(doc.exists ? doc.data() : {}) });
});

const profileSchema = z.object({
  displayName: z.string().max(100).optional(),
  preferences: z.object({
    budget: z.string().optional(),
    accessibilityNotes: z.string().max(500).optional(),
    interests: z.array(z.string()).max(20).optional()
  }).optional()
});

usersRouter.patch("/me", async (req, res) => {
  const parsed = profileSchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ error: parsed.error.flatten() });
  await db.collection("users").doc(req.user!.uid).set({ ...parsed.data, updatedAt: new Date() }, { merge: true });
  res.json({ ok: true });
});
