import { initializeApp, applicationDefault } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";

initializeApp({ credential: applicationDefault() });
const db = getFirestore();

const resources = [
  { id: "sfsu-transit-info", name: "SFSU Transportation Information", description: "Campus transportation and commuting information.", category: "transportation", costLabel: "varies", eligibility: "SFSU students; verify specific program eligibility at source", locationName: "San Francisco State University", sourceUrl: "https://parking.sfsu.edu/", sourceName: "SFSU", isActive: true, tags: ["commute", "transit", "campus"] },
  { id: "sfsu-basic-needs", name: "SFSU Basic Needs", description: "Campus resources supporting food, housing, and other essential needs.", category: "basic-needs", costLabel: "free/varies", eligibility: "See source for current eligibility", locationName: "San Francisco State University", sourceUrl: "https://basicneeds.sfsu.edu/", sourceName: "SFSU", isActive: true, tags: ["food", "support", "student"] }
];

const landmarks = [
  { id: "thornton-hall", name: "Thornton Hall", description: "Campus academic landmark.", latitude: 37.7232, longitude: -122.4769, claimRadiusM: 90, category: "campus-essential", collectionIds: ["campus-essentials"], isActive: true },
  { id: "holloway-quad", name: "Holloway Quad", description: "Central campus gathering area.", latitude: 37.7218, longitude: -122.4782, claimRadiusM: 100, category: "campus-essential", collectionIds: ["campus-essentials"], isActive: true }
];

async function run() {
  const batch = db.batch();
  for (const r of resources) batch.set(db.collection("resources").doc(r.id), { ...r, lastVerifiedAt: new Date(), updatedAt: new Date() });
  for (const l of landmarks) batch.set(db.collection("landmarks").doc(l.id), { ...l, updatedAt: new Date() });
  batch.set(db.collection("collections").doc("campus-essentials"), { name: "Campus Essentials", description: "Important places for new and current students.", category: "campus", isActive: true, updatedAt: new Date() });
  await batch.commit();
  console.log("Seed complete");
}

run().catch(err => { console.error(err); process.exit(1); });
