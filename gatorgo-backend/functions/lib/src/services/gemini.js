import { GoogleGenAI } from "@google/genai";
import { config } from "../config.js";
const schema = {
    type: "object",
    properties: {
        intent: { type: "string" },
        summary: { type: "string" },
        recommendations: {
            type: "array",
            items: {
                type: "object",
                properties: {
                    recordType: { type: "string", enum: ["resource", "route"] },
                    recordId: { type: "string" },
                    reason: { type: "string" },
                    tradeoffs: { type: "array", items: { type: "string" } },
                    nextStep: { type: "string" }
                },
                required: ["recordType", "recordId", "reason", "tradeoffs", "nextStep"]
            }
        },
        caveats: { type: "array", items: { type: "string" } }
    },
    required: ["intent", "summary", "recommendations", "caveats"]
};
export async function groundedRecommendation(input) {
    const apiKey = process.env.GEMINI_API_KEY;
    if (!apiKey)
        throw new Error("GEMINI_API_KEY is not configured");
    const ai = new GoogleGenAI({ apiKey });
    const allowedResourceIds = new Set(input.resources.map(x => x.id));
    const allowedRouteIds = new Set((input.routes || []).map(x => x.id));
    const prompt = [
        "You are GatorGo, an SFSU student mobility and resource assistant.",
        "Use ONLY the supplied candidate records. Never invent fares, schedules, eligibility rules, discounts, events, or IDs.",
        "If evidence is insufficient, say so in caveats. Prefer concise, practical explanations.",
        `USER_QUERY: ${input.query}`,
        `RESOURCE_CANDIDATES: ${JSON.stringify(input.resources)}`,
        `ROUTE_CANDIDATES: ${JSON.stringify(input.routes || [])}`
    ].join("\n\n");
    const response = await ai.models.generateContent({
        model: config.geminiModel,
        contents: prompt,
        config: {
            responseMimeType: "application/json",
            responseSchema: schema,
            temperature: 0.2
        }
    });
    const parsed = JSON.parse(response.text || "{}");
    parsed.recommendations = (parsed.recommendations || []).filter((r) => r.recordType === "resource" ? allowedResourceIds.has(r.recordId) : allowedRouteIds.has(r.recordId));
    return parsed;
}
