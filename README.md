# Mystery Protocol — Campus Expedition

A browser-based, Pokémon GO-inspired campus exploration interface for Tech Week.

## Open a preview
The static app entry point is `index.html`. A quick hosted preview is available with a static raw-file host; permanent GitHub Pages hosting requires Pages to be enabled for this repository.

## Current features
- Satellite and street-map base layers centered on Brindavan College of Engineering.
- 2D top-down and 3D tilted views, plus extruded building footprints loaded from OpenStreetMap when data is available.
- Animated player avatar, pulsing mission beacons, level/XP HUD, scan pulse, mission journal and checkpoint completion.
- GPS location tracking (requires browser permission and HTTPS).
- Organiser console to place checkpoints at verified campus locations; checkpoint locations are not fabricated.
- Walking-route display using public OpenStreetMap routing services; preview mode can animate the avatar along the calculated route.
- JSON import/export for checkpoint setup and transfer between devices. Checkpoints and XP are stored locally in the current browser.

## Preview
Open `index.html` through a static host or run any static file server in this directory.

## Enable permanent GitHub Pages hosting
1. Open repository **Settings → Pages**.
2. Under Build and deployment, choose **GitHub Actions** as the source.
3. Open **Actions → Deploy Mystery Protocol Map → Run workflow**.

The deployment workflow is manual because GitHub Pages is not currently enabled on the repository. The workflow cannot enable Pages itself without the repository's Pages administration permission.

## Campus accuracy
The initial camera is centered on the publicly mapped college location. 3D building shapes depend on available OpenStreetMap footprints. Organiser must place event checkpoints using the actual campus reference/video before the app is used for live event navigation.

## Data services
Map imagery: Esri World Imagery (attribution shown on map).
Street map and building footprints: OpenStreetMap contributors.
Elevation: AWS Terrain Tiles.
Walking routes: public OpenStreetMap-based routing services.
