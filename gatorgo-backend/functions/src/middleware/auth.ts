import type { NextFunction, Request, Response } from "express";
import { auth } from "../firebase.js";

declare global {
  namespace Express {
    interface Request { user?: { uid: string; email?: string } }
  }
}

export async function optionalAuth(req: Request, _res: Response, next: NextFunction) {
  const header = req.headers.authorization;
  if (!header?.startsWith("Bearer ")) return next();
  try {
    const decoded = await auth.verifyIdToken(header.slice(7));
    req.user = { uid: decoded.uid, email: decoded.email };
  } catch {
    // Optional endpoints continue anonymously.
  }
  next();
}

export async function requireAuth(req: Request, res: Response, next: NextFunction) {
  const header = req.headers.authorization;
  if (!header?.startsWith("Bearer ")) return res.status(401).json({ error: "Authentication required" });
  try {
    const decoded = await auth.verifyIdToken(header.slice(7));
    req.user = { uid: decoded.uid, email: decoded.email };
    next();
  } catch {
    res.status(401).json({ error: "Invalid or expired Firebase ID token" });
  }
}
