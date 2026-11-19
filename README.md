# Music Player & Video Downloader

A free Android app with a local music player and a narrowly scoped direct-media link downloader.

## Included
- Select audio files on the device and play them as a queue.
- Background playback and Android media notification controls.
- Download a directly addressable HTTPS media file when the source permits it, using Android's save-file picker.
- No account, database, backend, cloud storage, photo gallery, image tools, video gallery, or general file manager.

## Important source limitations
This build downloads direct file URLs only. A YouTube, TikTok, Instagram, or other platform watch-page URL is not a direct media file URL and is not supported by this downloader. The app does not bypass DRM, platform restrictions, paywalls, or private-content protections.

This initial release does not transcode between formats or extract audio from arbitrary platform pages. Those capabilities require a compatible, legally authorized source and a local conversion engine; they must not be advertised until implemented and tested.

## Build
GitHub Actions builds both a release APK (for direct distribution) and an Android App Bundle (AAB) for Google Play. The workflow artifact is available for 14 days after a successful run.
