# Mystery Protocol — Campus Expedition

A browser-based campus exploration experience for Tech Week at Brindavan College of Engineering.

## Open the app
- Entry point: `index.html`
- Preview: use the commit-pinned static preview URL shared in the project conversation.
- Permanent GitHub Pages hosting requires Pages to be enabled in repository settings.

## Map modes
- **2D:** draggable satellite/street map with campus landmarks, zoom, GPS, discovery progress, and route guidance.
- **3D:** an independent Three.js WebGL world. Satellite tiles are placed on the ground plane; OSM building footprints are extruded into walls/roofs; mapped roads and paths are built as geometry; the orbit camera can rotate, tilt, pan, and zoom.
- The player avatar and mission beacons render as actual 3D objects and sync with the 2D map state.

## Gameplay
- The map starts with five real public-map landmarks: Engineering College, IS & CS Block, Architecture Block, College Canteen, and Boys Hostel II.
- Visit a landmark with GPS enabled to log a discovery and earn XP. Preview mode supports manual free-roam testing.
- The Organiser console adds/removes points at map-selected positions and imports/exports checkpoint JSON.
- Checkpoint locations and progress are saved locally in the browser.
- Walking routes use public OpenStreetMap-based routing services.

## Accuracy and sources
- Initial focus: publicly mapped Brindavan College of Engineering location, 13.12461, 77.62029.
- Building footprints, building names and road geometry come from OpenStreetMap contributors.
- Landmark coordinate records are from public place/map listings; organisers should validate any event-specific clue route on campus before the event.
- Where a building has no height tag, its height is estimated for visualisation. The 3D scene models the mapped footprint, not interior room layout or an official architectural BIM model.

## Data services and attribution
- Satellite imagery: Esri World Imagery (attribution in map UI).
- Street map, building footprints, mapped roads/trees: © OpenStreetMap contributors.
- Walking routes: public OpenStreetMap-based routing services.
