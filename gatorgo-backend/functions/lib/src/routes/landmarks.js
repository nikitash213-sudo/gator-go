import { Router } from "express";
import { z } from "zod";
import { db } from "../firebase.js";
import { requireAuth } from "../middleware/auth.js";
import { haversineMeters } from "../utils/distance.js";
export const landmarksRouter = Router();
landmarksRouter.get("/", async (_req, res) => {
    const snap = await db.collection("landmarks").where("isActive", "==", true).get();
    res.json({ landmarks: snap.docs.map(d => ({ id: d.id, ...d.data() })) });
});
const claimSchema = z.object({ latitude: z.number().gte(-90).lte(90), longitude: z.number().gte(-180).lte(180) });
landmarksRouter.post("/:id/claim", requireAuth, async (req, res) => {
    const parsed = claimSchema.safeParse(req.body);
    if (!parsed.success)
        return res.status(400).json({ error: parsed.error.flatten() });
    const landmarkId = Array.isArray(req.params.id) ? req.params.id[0] : req.params.id;
    const doc = await db.collection("landmarks").doc(landmarkId).get();
    if (!doc.exists)
        return res.status(404).json({ error: "Landmark not found" });
    const landmark = { id: doc.id, ...doc.data() };
    const distanceM = haversineMeters(parsed.data.latitude, parsed.data.longitude, landmark.latitude, landmark.longitude);
    if (distanceM > landmark.claimRadiusM) {
        return res.status(403).json({ error: "Outside claim radius", distanceM: Math.round(distanceM), allowedRadiusM: landmark.claimRadiusM });
    }
    const claimId = `${req.user.uid}_${landmark.id}`;
    await db.collection("landmarkClaims").doc(claimId).set({
        userId: req.user.uid,
        landmarkId: landmark.id,
        claimedAt: new Date(),
        verificationMethod: "gps_proximity",
        verifiedDistanceM: Math.round(distanceM)
    }, { merge: true });
    res.json({ claimed: true, landmarkId: landmark.id, distanceM: Math.round(distanceM) });
});
landmarksRouter.get("/me/claims", requireAuth, async (req, res) => {
    const snap = await db.collection("landmarkClaims").where("userId", "==", req.user.uid).get();
    res.json({ claims: snap.docs.map(d => ({ id: d.id, ...d.data() })) });
});
