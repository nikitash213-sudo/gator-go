import { auth } from "../firebase.js";
export async function optionalAuth(req, _res, next) {
    const header = req.headers.authorization;
    if (!header?.startsWith("Bearer "))
        return next();
    try {
        const decoded = await auth.verifyIdToken(header.slice(7));
        req.user = { uid: decoded.uid, email: decoded.email };
    }
    catch {
        // Optional endpoints continue anonymously.
    }
    next();
}
export async function requireAuth(req, res, next) {
    const header = req.headers.authorization;
    if (!header?.startsWith("Bearer "))
        return res.status(401).json({ error: "Authentication required" });
    try {
        const decoded = await auth.verifyIdToken(header.slice(7));
        req.user = { uid: decoded.uid, email: decoded.email };
        next();
    }
    catch {
        res.status(401).json({ error: "Invalid or expired Firebase ID token" });
    }
}
