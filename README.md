# Media Master

Media Master is an Android-first Flutter app with a deliberately small scope:

1. **Music player** — play audio files stored locally on the device, with background playback planned.
2. **Link-based media downloader and converter** — enter an internet URL, select an output format, and download/convert content only when the source permits it and the user has the necessary rights.

## Explicitly out of scope

- Photo gallery, image tools, or photo downloading.
- Downloading personal videos from the device.
- General-purpose file manager.
- Bypassing DRM, paywalls, access controls, platform restrictions, or private-content protections.
- Accounts, a backend server, or a database.

## Current development status

The current commit updates the app's navigation and screens to reflect the agreed scope. The link field currently performs only basic URL syntax validation; it does **not** download or convert media yet. The music screen is currently a UI placeholder; local audio selection and playback are not implemented yet.

The next development stages are:
- Add local audio file selection and playback, then test background playback.
- Add source-specific, permitted URL handling; do not promise universal support for every social platform.
- Add on-device media conversion and verify output files on Android.
- Build and test a release APK before calling the app ready.

## Build

The GitHub Actions workflow `.github/workflows/android-apk.yml` builds a release APK on pushes to `main` and uploads it as the `media-master-android-apk` artifact when the build succeeds.
