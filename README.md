# Flutter News App

This Flutter project fetches news articles from NewsAPI, allowing users to browse the latest news, 
save their favorite articles and open articles directly in the browser for further reading.

# Requirements

Flutter SDK 3.0.0 or higher
Dart SDK (included with Flutter)
Android Studio or VS Code
Android emulator (e.g., Pixel 6 API 35) or iOS simulator (macOS only, e.g., iPhone 15 Pro, iOS 18.0)
NewsAPI key: 'cd2e5aa04cfe4efd9a1eb1d16e54f53b'

# Setup Instructions

1. Clone the repository:
git clone https://github.com/cristianmarcu/Flutter_News
cd Dart_Task

2. Install dependencies:
flutter pub get

3. Run the app:
flutter clean
flutter pub get
flutter run

# Expected Output

Favorites Tab shows saved articles with red heart icons.

# Notes

Uses url_launcher for opening articles, shared_preferences for favorites,
and flutter_launcher_icons for the app icon.
AndroidManifest.xml includes INTERNET permission and <queries> for URL launching.
article_tile.dart uses mounted checks for async operations and debug.
Comments in Dart files explain functionality for review.
Project is cleaned to include only Android/IOs files.

# Possible Improvements

Add in-aoo article details page.
Implement offline article caching.
Add search for news articles.
Support multiple news categories.