export const config = {
    region: process.env.FUNCTION_REGION || "us-west1",
    geminiModel: process.env.GEMINI_MODEL || "gemini-2.5-flash-lite",
    landmarkDefaultRadiusM: Number(process.env.LANDMARK_DEFAULT_RADIUS_M || 80),
    maxResourceCandidates: Number(process.env.MAX_RESOURCE_CANDIDATES || 20),
};
