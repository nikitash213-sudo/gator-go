import { db } from "../firebase.js";
import { config } from "../config.js";
export async function getResources(filters = {}) {
    let q = db.collection("resources").where("isActive", "==", true);
    if (filters.category)
        q = q.where("category", "==", filters.category);
    const snap = await q.limit(config.maxResourceCandidates).get();
    let items = snap.docs.map(d => ({ id: d.id, ...d.data() }));
    if (filters.query) {
        const words = filters.query.toLowerCase().split(/\s+/).filter(Boolean);
        items = items.filter(r => {
            const haystack = [r.name, r.description, r.category, r.eligibility, ...(r.tags || [])].join(" ").toLowerCase();
            return words.some(w => haystack.includes(w));
        });
    }
    return items;
}
