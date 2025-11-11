# Pokémon TCG Collection App 🎴# Pokémon TCG Mobile App

A modern, responsive Flutter web/mobile application for browsing and managing Pokémon trading cards with beautiful UI, real-time search, and seamless API integration.A Flutter mobile application for managing Pokémon trading cards using the Pokémon TCG API and SQLite local storage.

![Flutter](https://img.shields.io/badge/Flutter-3.35.5-blue.svg)## Features

![Dart](https://img.shields.io/badge/Dart-3.6.0-blue.svg)

![License](https://img.shields.io/badge/license-MIT-green.svg)- ✅ Fetch Pokémon cards from the official Pokémon TCG API

- ✅ Store cards locally using SQLite (no Firebase)

## ✨ Features- ✅ Display cards in a scrollable list with images and names

- ✅ Tap any card to view full-size image in detail screen

### Core Functionality- ✅ Pull to refresh functionality

- 🎯 **API Integration** - Fetches 50 Pokémon cards from the official Pokémon TCG API- ✅ Loading indicators and error handling

- 💾 **Dual Storage System** - SQLite for mobile, localStorage (SharedPreferences) for web (no Firebase)- ✅ Clean Material Design UI

- 🔍 **Real-time Search** - Instant filtering by Pokémon name as you type

- 📊 **Alphabetical Sorting** - Cards automatically sorted A-Z for easy browsing## Project Structure

- 🖼️ **Full-screen Detail View** - Tap any card to see enlarged image with zoom capability

- ♻️ **Smart Refresh** - Refresh button to fetch latest cards from API```

- ⚡ **Offline Support** - Cards cached locally for instant loading on subsequent visitslib/

- 🌐 **Cross-Platform** - Works on web, Android, iOS, and desktop├── main.dart # Main UI with ListView and navigation

├── db_helper.dart # SQLite database setup and operations

### UI/UX Enhancements├── card_detail_screen.dart # Detail screen showing enlarged card image

- 🎨 **Pokémon-Inspired Theme** - Official Pokémon Red (#DC0A2D) and Yellow (#FFCB05) colors└── services/

- 🌊 **Gradient Background** - Beautiful light blue gradient (#E3F4FD to #B3D9F2) └── api_service.dart # API service to fetch and store cards

- 📱 **Fully Responsive Design** - Adaptive layouts for mobile (<600px) and desktop (≥600px)```

- ✨ **Smooth Animations** - Hover effects, Hero transitions, and loading states

- ⚪ **Custom Pokéball Loader** - Animated spinning Pokéball during data fetch## Database Schema

- 🎯 **Sticky Search Bar** - Search bar with clear button stays accessible

- 🖱️ **Hover Effects** - Cards elevate with shadow on mouse hover (desktop only)**Table: cards**

- 💳 **Material 3 Design** - Modern Material Design 3 components and styling

- 🔄 **Smart Layout Switching** - Stacked layout (mobile) vs Row layout (desktop)- `id` TEXT PRIMARY KEY

- `name` TEXT

## 🎬 Screenshots- `imageSmall` TEXT

- `imageLarge` TEXT

### Desktop View

- Large card images on the left## Dependencies

- Card details in the center

- Arrow icon on the right- `http` - HTTP requests to Pokémon TCG API

- Hover effects with elevation- `sqflite` - SQLite database for local storage

- `path_provider` - Get application documents directory

### Mobile View- `path` - Path manipulation utilities

- Card image stacked on top

- Card name below the image## How to Run

- Optimized for touch interaction

- Compact, scrollable layout### Prerequisites

## 📁 Project Structure- Flutter SDK installed (3.0.0 or higher)

- Android emulator/device or iOS simulator/device

````- Internet connection (for first-time card fetch)

pokemon/

├── lib/### Steps

│   ├── main.dart                    # Main app with responsive UI, search & card display

│   ├── card_detail_screen.dart      # Full-screen detail view with zoom1. **Install dependencies:**

│   ├── db_helper.dart               # SQLite database for mobile platforms

│   ├── web_db_helper.dart           # localStorage/SharedPreferences for web   ```bash

│   └── services/   flutter pub get

│       └── api_service.dart         # Pokémon TCG API integration with platform detection   ```

├── web/

│   ├── index.html                   # Web entry point2. **Run the app:**

│   ├── manifest.json                # PWA manifest

│   └── icons/                       # App icons   ```bash

├── pubspec.yaml                     # Dependencies and project config   flutter run

└── README.md                        # This file   ```

````

3. **Or build for specific platform:**

## 🗄️ Database Schema

````bash

### Mobile (SQLite)   # Android

**Table: `cards`**   flutter run -d android

- `id` TEXT PRIMARY KEY - Unique card identifier

- `name` TEXT - Pokémon card name   # iOS

- `imageSmall` TEXT - URL for thumbnail image   flutter run -d ios

- `imageLarge` TEXT - URL for full-size image

# Web (if enabled)

### Web (localStorage)   flutter run -d chrome

- Stores cards as JSON array in SharedPreferences   ```

- Same data structure as SQLite for consistency

- Automatically detects platform using `kIsWeb`## How It Works



## 📦 Dependencies1. **First Launch:**



```yaml   - App checks if SQLite database has any cards

dependencies:   - If empty, fetches 50 cards from `https://api.pokemontcg.io/v2/cards?pageSize=50`

flutter:   - Stores all cards in local SQLite database

 sdk: flutter   - Displays cards in ListView

http: ^1.1.0                    # HTTP requests to Pokémon TCG API

sqflite: ^2.3.0                 # SQLite database for mobile2. **Subsequent Launches:**

path_provider: ^2.1.1           # Access file system paths

path: ^1.8.3                    # Path manipulation   - Loads cards directly from SQLite (no API call needed)

shared_preferences: ^2.2.2      # Web storage solution   - Instant loading with no network dependency

````

3. **Card Interaction:**

## 🚀 How to Run - Tap any card in the list to open detail screen

- Detail screen shows full-size card image with zoom capability

### Prerequisites - Tap refresh icon to fetch fresh data from API

- Flutter SDK 3.0.0 or higher

- Dart SDK 3.0.0 or higher## UI Components

- Chrome browser (for web)

- Android Studio / Xcode (for mobile)- **Main Screen:** ListView with card thumbnails and names

- Internet connection (for first-time card fetch)- **Detail Screen:** Full-screen card image with Hero animation

- **Loading State:** Circular progress indicator while fetching

### Installation- **Error State:** Error message with retry button

- **Refresh:** Pull-down to refresh or tap refresh icon

1. **Clone the repository:**

   ````bash## API Information

   git clone https://github.com/laxmi215/pokemon-cards.git

   cd pokemon-cards- **Endpoint:** https://api.pokemontcg.io/v2/cards

   ```- **Page Size:** 50 cards per request
   ````

- **No API key required**

2. **Install dependencies:**

   ````bash## No Modification Required

   flutter pub get

   ```This code compiles and runs without any modifications. All imports are correct, and the architecture follows Flutter best practices.

   ````

3. **Run on Web (with CORS disabled for API access):**---

   ````bash

   flutter run -d chrome --web-browser-flag="--disable-web-security"**Developed with Flutter** 🎯

   ```"# pokemon-cards"


   Or build and serve:
   ```bash
   flutter build web
   cd build/web
   python -m http.server 8000
   ````

   Then open Chrome with: `chrome.exe --disable-web-security --user-data-dir="C:\temp\chrome_dev" http://localhost:8000`

4. **Run on Mobile:**

   ```bash
   # Android
   flutter run -d android

   # iOS
   flutter run -d ios
   ```

## 🔧 How It Works

### First Launch

1. App initializes appropriate storage (SQLite for mobile, SharedPreferences for web)
2. Checks if local storage has any cards
3. If empty, fetches 50 cards from `https://api.pokemontcg.io/v2/cards?pageSize=50`
4. Stores all cards locally for offline access
5. Displays cards in a responsive grid/list

### Subsequent Launches

1. Loads cards directly from local storage (instant loading)
2. No API call needed unless user clicks refresh
3. Search and filter work entirely offline

### Search Functionality

1. User types in search bar
2. App filters cards in real-time by name
3. Results update instantly as you type
4. Clear button to reset search

### Card Interaction

1. Tap any card to open detail screen
2. Full-size image loads with Hero animation
3. Pinch/scroll to zoom on image
4. Back button returns to main list

## 💻 Code Highlights

### Responsive Layout Detection

```dart
// Automatically switches between mobile and desktop layouts
LayoutBuilder(
  builder: (context, constraints) {
    final isMobile = constraints.maxWidth < 600;
    return isMobile ? _buildMobileLayout() : _buildDesktopLayout();
  }
)
```

### Platform-Aware Storage

```dart
// Uses kIsWeb to detect platform and choose appropriate storage
import 'package:flutter/foundation.dart' show kIsWeb;

if (kIsWeb) {
  // Use SharedPreferences for web
  final prefs = await SharedPreferences.getInstance();
} else {
  // Use SQLite for mobile
  final db = await DatabaseHelper.instance.database;
}
```

### Real-time Search

```dart
// Search controller updates filtered list on every keystroke
_searchController.addListener(() {
  _filterCards();
});
```

## 🎨 UI Components

### Main Screen

- **App Bar:** Red background with "Pokémon Collection" title and refresh button
- **Search Bar:** Sticky white search field with 🔍 icon and clear button
- **Results Count:** Shows "X Pokémon" with "All" or "Filtered" badge
- **Card Grid:** Responsive list of Pokémon cards
- **Loading State:** Animated Pokéball spinner

### Detail Screen

- **Hero Animation:** Smooth transition from thumbnail to full image
- **Interactive Viewer:** Pinch to zoom, pan to explore
- **App Bar:** Card name with back button
- **Gradient Background:** Matches main screen theme

## 🌐 API Information

- **Endpoint:** https://api.pokemontcg.io/v2/cards
- **Page Size:** 50 cards per request
- **No Authentication:** No API key required
- **CORS:** Web version requires CORS disabled in Chrome for development

## 🤝 Contributions

### AI Assistant Contributions

This project was developed with assistance from GitHub Copilot, which contributed:

1. **Architecture & Code Structure**

   - Designed clean separation between UI, services, and data layers
   - Implemented platform detection pattern for web/mobile compatibility
   - Created reusable, well-commented code components

2. **Responsive UI Implementation**

   - Built mobile-first responsive layouts using LayoutBuilder
   - Designed Pokémon-themed color scheme and gradient backgrounds
   - Implemented smooth animations and hover effects
   - Created custom Pokéball loading spinner

3. **Feature Development**

   - Real-time search with debouncing and filtering
   - Alphabetical sorting logic
   - Dual storage system (SQLite + SharedPreferences)
   - Hero animations for card transitions
   - Pull-to-refresh and error handling

4. **Code Quality**

   - Added comprehensive inline comments explaining logic
   - Followed Flutter best practices and Material Design guidelines
   - Ensured cross-platform compatibility
   - Optimized performance with proper state management

5. **Documentation**
   - Created detailed README with setup instructions
   - Documented all features and technical decisions
   - Provided code examples and architecture overview

### Code Comments

All major functions include inline comments explaining:

- Purpose of each function
- Parameter descriptions
- Logic flow and decision points
- Platform-specific implementations

## 📝 License

This project is open source and available under the MIT License.

## 🙏 Acknowledgments

- **Pokémon TCG API** - For providing free access to Pokémon card data
- **Flutter Team** - For the amazing cross-platform framework
- **Material Design** - For UI/UX design guidelines
- **GitHub Copilot** - For AI-assisted development

---

**Built with Flutter** 💙 | **Pokémon © Nintendo/Creatures Inc./GAME FREAK inc.**

_Note: This is a fan project and is not affiliated with or endorsed by Nintendo, Creatures Inc., or GAME FREAK inc._
