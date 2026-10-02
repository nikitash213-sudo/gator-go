const EARTH_RADIUS_M = 6371000;
const rad = (d) => d * Math.PI / 180;
export function haversineMeters(aLat, aLng, bLat, bLng) {
    const dLat = rad(bLat - aLat);
    const dLng = rad(bLng - aLng);
    const x = Math.sin(dLat / 2) ** 2 + Math.cos(rad(aLat)) * Math.cos(rad(bLat)) * Math.sin(dLng / 2) ** 2;
    return 2 * EARTH_RADIUS_M * Math.asin(Math.sqrt(x));
}
