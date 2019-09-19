# Minimal Ebiten-Powered Android App

<p align="center">
    <img src="screenshot.png" width="320" align="center"/>
</p>

This project serves as an example how to build minimal working Ebiten-powered
Android application **without** Android Studio or Gradle.

Check annotated `Makefile` to see which commands from Android SDK are used to
build working APK.

## Requirements

To be able to build applications for Android, following dependencies are
required:

* Android SDK,
* Android NDK,
* Java,
* ebiten (`go get github.com/hajimehoshi/ebiten/cmd/ebitenmobile`).

For **Arch Linux** users, following packages should be installed:

* AUR: `android-sdk` (version 26),
* AUR: `android-sdk-build-tools`,
* AUR: `android-sdk-platform-tools`,
* AUR: `android-platform` (version 29),
* AUR: `android-ndk` (version 20),
* `java-environment-common`,
* `java-runtime-common`.

## End-To-End Test

Connect your Android device, make sure that it's visible to `adb` and
run `make run`.
