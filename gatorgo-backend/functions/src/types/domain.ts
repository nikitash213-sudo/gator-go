export type Resource = {
  id: string;
  name: string;
  description: string;
  category: string;
  costLabel?: string;
  eligibility?: string;
  locationName?: string;
  latitude?: number;
  longitude?: number;
  sourceUrl: string;
  sourceName?: string;
  lastVerifiedAt?: string;
  expiresAt?: string | null;
  isActive: boolean;
  tags?: string[];
};

export type Landmark = {
  id: string;
  name: string;
  description: string;
  latitude: number;
  longitude: number;
  claimRadiusM: number;
  category: string;
  collectionIds: string[];
  isActive: boolean;
};

export type RouteCandidate = {
  id: string;
  mode: string;
  durationMinutes?: number;
  estimatedCost?: string;
  transfers?: number;
  walkingMinutes?: number;
  summary?: string;
  source?: string;
};
