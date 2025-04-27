name: Flutter CI/CD

on:
push:
branches:
- main
pull_request:
branches:
- main

jobs:
build:
runs-on: ubuntu-latest

steps:
# Checkout the repository code
- name: Checkout code
uses: actions/checkout@v4

# Set up Java (required for Android builds)
- name: Set up JDK 17
uses: actions/setup-java@v4
with:
distribution: 'zulu'
java-version: '17'

# Set up Flutter
- name: Set up Flutter
uses: subosito/flutter-action@v2
with:
flutter-version: '3.24.3' # Specify your Flutter version
channel: 'stable'
cache: true

# Get dependencies
- name: Install dependencies
run: flutter pub get

# Run tests
- name: Run tests
run: flutter test

# Build APK
- name: Build APK
run: flutter build apk --release

# Upload APK as artifact
- name: Upload APK
uses: actions/upload-artifact@v4
with:
name: app-release.apk
path: build/app/outputs/flutter-apk/app-release.apk