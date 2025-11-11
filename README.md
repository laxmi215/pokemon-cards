# Pokémon Battle Arena ⚔️

A modern, visually appealing Flutter web application that uses the PokéAPI to create exciting Pokémon battles. Two random Pokémon face off, comparing their HP stats to determine the winner!

![Flutter](https://img.shields.io/badge/Flutter-3.35.5-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.6.0-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## ✨ Features

### Core Functionality

- 🎯 **Random Pokémon Selection** - Fetches 2 random Pokémon from 898 available in PokéAPI
- ⚔️ **HP Battle System** - Compares HP (base stats) and declares the winner
- 🔄 **NEW BATTLE Button** - Click to instantly load a new battle with different Pokémon
- 🖼️ **Official Artwork** - Displays high-quality official Pokémon artwork
- ⚡ **Fast & Reliable** - Uses PokéAPI for consistent, error-free performance

### UI/UX Enhancements

- 🎨 **Pokémon-Inspired Theme** - Official Pokémon Red (#DC0A2D) and Yellow (#FFCB05) colors
- 🌊 **Light Blue Background** - Soothing light blue backdrop for comfortable viewing
- 🏆 **Winner Highlighting** - Gold border and trophy badge for the winning Pokémon
- ✨ **Smooth Animations** - Scale animations and visual effects when winner is declared
- 📱 **Fully Responsive Design** - Adapts to mobile (<600px) and desktop (≥600px)
- 💳 **Material 3 Design** - Modern Material Design 3 components
- 🚫 **No Debug Banner** - Clean, production-ready appearance

## 📁 Project Structure

```
pokemon/
├── lib/
│   ├── main.dart                    # Battle Arena app with API integration
│   └── main_pokeapi.dart           # Backup version with PokéAPI
├── pubspec.yaml                     # Dependencies and project config
└── README.md                        # This file
```

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0 # HTTP requests to PokéAPI
```

## 🚀 How to Run

### Prerequisites

- Flutter SDK 3.0.0 or higher
- Dart SDK 3.0.0 or higher
- Chrome browser (for web)
- Internet connection (for API access)

### Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/laxmi215/pokemon-cards.git
   cd pokemon
   ```

2. **Install dependencies:**

   ```bash
   flutter pub get
   ```

3. **Run on Web (with CORS disabled for API access):**
   ```bash
   flutter run -d chrome --web-browser-flag="--disable-web-security"
   ```

## 🔧 How It Works

### Battle Flow

1. **App Launch**

   - Automatically fetches 2 random Pokémon from PokéAPI (IDs 1-898)
   - Shows loading spinner while data is being fetched

2. **Battle Display**

   - Displays both Pokémon with their names, images, and HP
   - Compares HP values to determine the winner
   - Highlights winner with gold border and trophy badge
   - Shows "IT'S A TIE!" if HP values are equal

3. **New Battle**
   - User clicks "NEW BATTLE" button
   - App fetches 2 new random Pokémon
   - Winner is recalculated and displayed

### API Integration

- **Endpoint:** https://pokeapi.co/api/v2/pokemon/{id}
- **Random Selection:** Random IDs from 1-898
- **Data Retrieved:** Name, HP (base_stat), official artwork
- **Timeout:** 10 seconds per Pokémon fetch
- **Error Handling:** User-friendly error messages with retry option

## 💻 Code Highlights

### Responsive Layout

```dart
// Automatically switches between mobile (Column) and desktop (Row) layouts
LayoutBuilder(
  builder: (context, constraints) {
    final isWide = constraints.maxWidth > 600;
    return isWide
        ? Row(children: [...])  // Desktop: side-by-side
        : Column(children: [...]); // Mobile: stacked
  }
)
```

### Random Pokémon Selection

```dart
// Generate random Pokémon IDs from 1 to 898
final id1 = random.nextInt(898) + 1;
final id2 = random.nextInt(898) + 1;
```

### Winner Calculation

```dart
// Compare HP values to determine winner (1, 2, or 0 for tie)
final compWinner = fetchedCards[0].hp > fetchedCards[1].hp
    ? 1
    : (fetchedCards[1].hp > fetchedCards[0].hp ? 2 : 0);
```

## 🎨 UI Components

### Main Screen

- **App Bar:** Red background with Pokéball icon and "Pokémon Battle Arena" title
- **Winner Banner:** Gold gradient banner announcing the winner or tie
- **Battle Cards:** Two Pokémon displayed with images and HP
- **NEW BATTLE Button:** Floating action button at bottom
- **Loading State:** Circular progress indicator with "Loading Pokémon..." message

### Card Display

- **Winner Badge:** Gold "WINNER" badge with trophy icon
- **Pokémon Name:** Bold, uppercase name
- **Official Artwork:** High-quality image from PokéAPI
- **HP Display:** Heart icon with HP value highlighted in green for winner

## 🤝 Contributions

### AI Assistant Contributions

This Pokémon Battle Arena app was developed with assistance from GitHub Copilot AI, which contributed:

1. **Architecture & Code Structure**

   - Designed clean, single-file architecture for simplicity
   - Implemented PokemonCard model with JSON parsing
   - Created StatefulWidget with proper lifecycle management
   - Added AnimationController for winner effects

2. **API Integration**

   - Integrated PokéAPI with error handling and timeouts
   - Implemented random Pokémon selection from 898 available
   - Parsed JSON responses to extract name, HP, and artwork
   - Added retry logic and user-friendly error messages

3. **Battle Logic**

   - Created HP comparison algorithm to determine winner
   - Implemented tie detection (equal HP)
   - Added state management for loading, error, and battle states
   - Designed winner highlighting system

4. **Responsive UI Implementation**

   - Built mobile-first responsive layouts using LayoutBuilder
   - Designed Pokémon-themed color scheme (Red #DC0A2D, Yellow #FFCB05)
   - Created light blue background for visual appeal
   - Implemented gold winner highlighting with animations
   - Added trophy badges and visual effects

5. **Code Quality & Documentation**

   - Added comprehensive inline comments explaining all logic
   - Followed Flutter best practices and Material Design guidelines
   - Removed debug banner for clean appearance
   - Ensured cross-platform web compatibility

6. **Features Implemented**
   - ✅ Random Pokémon loading from PokéAPI
   - ✅ HP comparison and winner declaration
   - ✅ NEW BATTLE button functionality
   - ✅ Responsive mobile/desktop layouts
   - ✅ Error handling with retry options
   - ✅ Loading states and animations
   - ✅ Visual winner highlighting

### Code Documentation

All major functions include detailed inline comments explaining:

- Purpose and functionality
- Parameter descriptions
- Logic flow and decision points
- API interaction details
- State management approach

## 📝 Technical Notes

### Why PokéAPI Instead of Pokémon TCG API?

Initially attempted to use Pokémon TCG API (api.pokemontcg.io), but encountered:

- Persistent timeout errors (30+ seconds)
- CORS blocking issues
- Unreliable API responses

**Solution:** Switched to PokéAPI (pokeapi.co) which provides:

- ✅ Fast, reliable responses
- ✅ No authentication required
- ✅ Consistent uptime
- ✅ Official Pokémon data and artwork

## 📝 License

This project is open source and available under the MIT License.

## 🙏 Acknowledgments

- **PokéAPI** - For providing free, reliable Pokémon data
- **Flutter Team** - For the amazing cross-platform framework
- **Material Design** - For UI/UX design guidelines
- **GitHub Copilot** - For AI-assisted development and code documentation

---

**Built with Flutter** 💙 | **Pokémon © Nintendo/Creatures Inc./GAME FREAK inc.**

_Note: This is a fan project and is not affiliated with or endorsed by Nintendo, Creatures Inc., or GAME FREAK inc._

`````

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
`````
#   b a t t e l - o f - P o k - m o n - c a r d s  
 