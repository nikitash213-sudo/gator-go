import { Router } from "express";
import { z } from "zod";
import { getResources } from "../services/resources.js";
import { groundedRecommendation } from "../services/gemini.js";
import { db } from "../firebase.js";
import { optionalAuth } from "../middleware/auth.js";

const bodySchema = z.object({
  query: z.string().min(2).max(1000),
  category: z.string().optional(),
  routes: z.array(z.object({
    id: z.string(), mode: z.string(), durationMinutes: z.number().optional(),
    estimatedCost: z.string().optional(), transfers: z.number().optional(),
    walkingMinutes: z.number().optional(), summary: z.string().optional(), source: z.string().optional()
  })).max(10).optional()
});

export const aiRouter = Router();
aiRouter.use(optionalAuth);

aiRouter.post("/recommend", async (req, res) => {
  const parsed = bodySchema.safeParse(req.body);
  if (!parsed.success) return res.status(400).json({ error: parsed.error.flatten() });

  try {
    const resources = await getResources({ category: parsed.data.category, query: parsed.data.query });
    const answer = await groundedRecommendation({ query: parsed.data.query, resources, routes: parsed.data.routes });

    const ref = await db.collection("aiInteractions").add({
      userId: req.user?.uid || null,
      query: parsed.data.query,
      retrievedResourceIds: resources.map(r => r.id),
      retrievedRouteIds: (parsed.data.routes || []).map(r => r.id),
      response: answer,
      modelName: process.env.GEMINI_MODEL || "gemini-2.5-flash-lite",
      createdAt: new Date()
    });
    res.json({ interactionId: ref.id, ...answer, resources });
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: "Recommendation failed" });
  }
});
