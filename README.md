# Flutter News App

A Flutter mobile app that fetches news articles from NewsAPI, lets users browse the latest headlines, save favorite articles, and open full articles in the browser.

## Overview

Flutter News App is a cross-platform mobile project built with Flutter and Dart. It demonstrates API integration, local favorites persistence, external browser navigation, and simple mobile UI structure.

The app is designed as a portfolio project to show practical Flutter development skills, including working with REST APIs, managing local state, storing user preferences, and handling mobile platform configuration.

## Features

* Fetch latest news articles from NewsAPI
* Browse article cards with title, source, description, and image when available
* Save and remove favorite articles
* View saved articles in a dedicated Favorites tab
* Open full articles in the external browser
* Persist favorites locally using `shared_preferences`
* Android internet permission configured
* URL launching configured for supported platforms
* App icon configured with `flutter_launcher_icons`

## Tech Stack

* Flutter
* Dart
* NewsAPI
* `http`
* `shared_preferences`
* `url_launcher`
* `flutter_launcher_icons`
* Android Studio / VS Code

## Requirements

* Flutter SDK 3.0.0 or higher
* Dart SDK included with Flutter
* Android Studio or VS Code
* Android Emulator or iOS Simulator
* Personal NewsAPI key

## Setup Instructions

1. Clone the repository:

```bash
git clone https://github.com/cristianmarcu/Flutter_News.git
cd Flutter_News
```

2. Install dependencies:

```bash
flutter pub get
```

3. Add your own NewsAPI key locally.

Do not commit API keys to GitHub. Use your own local configuration method or replace the placeholder locally during development.

Example:

```dart
const String newsApiKey = 'YOUR_NEWS_API_KEY';
```

4. Run the app:

```bash
flutter clean
flutter pub get
flutter run
```

## Expected Behavior

* The app loads news articles from NewsAPI.
* Users can save articles as favorites.
* The Favorites tab displays saved articles.
* Favorite articles show a selected heart icon.
* Tapping an article opens it in the browser.

## Project Notes

* `url_launcher` is used to open articles externally.
* `shared_preferences` is used to persist favorite articles locally.
* `flutter_launcher_icons` is used for the app icon.
* `AndroidManifest.xml` includes internet permission and URL-launching queries.
* Async operations include mounted checks where needed.
* Dart files include comments to explain key functionality for review.

## Security Note

This project requires a NewsAPI key. API keys should not be committed to the repository or written directly in public documentation.

If an API key was previously exposed publicly, it should be revoked and replaced with a new one.

## Future Improvements

* Add in-app article detail screen
* Add article search
* Add category filters
* Add offline article caching
* Add loading skeletons
* Improve error handling for failed API requests
* Add unit tests for favorites logic
* Add UI tests for article and favorites flows

## Portfolio Focus

This project demonstrates:

* Flutter app structure
* REST API integration
* Local persistence
* Browser navigation
* Basic mobile UX patterns
* Cross-platform mobile development
