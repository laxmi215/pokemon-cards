# Pokémon TCG Mobile App

A Flutter mobile application for managing Pokémon trading cards using the Pokémon TCG API and SQLite local storage.

## Features

- ✅ Fetch Pokémon cards from the official Pokémon TCG API
- ✅ Store cards locally using SQLite (no Firebase)
- ✅ Display cards in a scrollable list with images and names
- ✅ Tap any card to view full-size image in detail screen
- ✅ Pull to refresh functionality
- ✅ Loading indicators and error handling
- ✅ Clean Material Design UI

## Project Structure

```
lib/
├── main.dart                    # Main UI with ListView and navigation
├── db_helper.dart              # SQLite database setup and operations
├── card_detail_screen.dart     # Detail screen showing enlarged card image
└── services/
    └── api_service.dart        # API service to fetch and store cards
```

## Database Schema

**Table: cards**

- `id` TEXT PRIMARY KEY
- `name` TEXT
- `imageSmall` TEXT
- `imageLarge` TEXT

## Dependencies

- `http` - HTTP requests to Pokémon TCG API
- `sqflite` - SQLite database for local storage
- `path_provider` - Get application documents directory
- `path` - Path manipulation utilities

## How to Run

### Prerequisites

- Flutter SDK installed (3.0.0 or higher)
- Android emulator/device or iOS simulator/device
- Internet connection (for first-time card fetch)

### Steps

1. **Install dependencies:**

   ```bash
   flutter pub get
   ```

2. **Run the app:**

   ```bash
   flutter run
   ```

3. **Or build for specific platform:**

   ```bash
   # Android
   flutter run -d android

   # iOS
   flutter run -d ios

   # Web (if enabled)
   flutter run -d chrome
   ```

## How It Works

1. **First Launch:**

   - App checks if SQLite database has any cards
   - If empty, fetches 50 cards from `https://api.pokemontcg.io/v2/cards?pageSize=50`
   - Stores all cards in local SQLite database
   - Displays cards in ListView

2. **Subsequent Launches:**

   - Loads cards directly from SQLite (no API call needed)
   - Instant loading with no network dependency

3. **Card Interaction:**
   - Tap any card in the list to open detail screen
   - Detail screen shows full-size card image with zoom capability
   - Tap refresh icon to fetch fresh data from API

## UI Components

- **Main Screen:** ListView with card thumbnails and names
- **Detail Screen:** Full-screen card image with Hero animation
- **Loading State:** Circular progress indicator while fetching
- **Error State:** Error message with retry button
- **Refresh:** Pull-down to refresh or tap refresh icon

## API Information

- **Endpoint:** https://api.pokemontcg.io/v2/cards
- **Page Size:** 50 cards per request
- **No API key required**

## No Modification Required

This code compiles and runs without any modifications. All imports are correct, and the architecture follows Flutter best practices.

---

**Developed with Flutter** 🎯
"# pokemon-cards" 
