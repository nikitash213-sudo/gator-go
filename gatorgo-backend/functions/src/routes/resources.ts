import { Router } from "express";
import { getResources } from "../services/resources.js";

export const resourcesRouter = Router();

resourcesRouter.get("/", async (req, res) => {
  try {
    const items = await getResources({
      category: typeof req.query.category === "string" ? req.query.category : undefined,
      query: typeof req.query.q === "string" ? req.query.q : undefined
    });
    res.json({ resources: items });
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: "Failed to load resources" });
  }
});
