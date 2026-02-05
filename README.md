# WarframeTools - Moroccan Luxury Void Relic Manager

Track your Warframe void relics, manage inventory, and sync across devices.

A modern Flutter application 🦋 for managing your Warframe void relic inventory 🔮. Track relics across all conditions (Intact ⚪, Exceptional 🥉, Flawless 🥈, Radiant 🌟), sync with a PocketBase backend ☁️, and organize your farming sessions 🚜 efficiently ⚡.

**Offline-First Architecture**: All 724 relics are bundled in the app. Works without an internet connection!

![WarframeTools](https://play.google.com/store/apps/details?id=com.omniversify.warframe.warframe_tools&hl=en)

## Features

### Relic Tracking
- **724 Relics** across 5 types: Lith, Meso, Neo, Axi, Requiem
- **4-Condition Counter System** - Track each relic separately:
  - Intact (transparent border)
  - Exceptional (gold circle)
  - Flawless (gold circle)
  - Radiant (gold circle)
- **Natural Sorting** - Relics sort correctly (Neo Z1, Z2, Z10, Z11) with Unvaulted items priority.
- **Search** - Fast, stadium-shaped search bar.
- **Filter by Type** - View Lith, Meso, Neo, Axi, or Requiem relics.

### Offline-First Design
- **All data bundled** - 690 relics included in APK
- **Local storage** - sqlite3 database for counters
- **No network required** - App works completely offline
- **Cloud sync optional** - Push/pull to PocketBase when available

### Inventory Management
- **Inventory View** - Shows total relics owned (sum of all conditions)
- **Per-Type Counts** - Each filter chip shows how many relics you own of that type
- **Total Available** - See how many relics exist for each type in the database
- **Statistics** - Detailed breakdown of your entire collection

- **PocketBase Integration**: Sync your inventory with a backend server (optional)
- **Local Backup**: Export/import data as JSON files
- **Cloud Sync**: Push and pull data from your PocketBase instance
- **Account Customization**: Change username, email, and choose from a collection of random avatars.
- **Email Verification**: Dedicated flow for verifying user accounts.

### Modern Luxury UI
- **Moroccan Luxury Design** - High-contrast Black & Gold theme.
- **Moon & Space Modes** - Choose between soft modern dark (`#1E1E1E`) or pure OLED black (`#000000`).
- **Fading Gold Ornamentation** - Subtle 20% gradient fade for borders and app bar highlights.
- **Premium Typography** - Uses `Cinzel` for elegant titles and `Source Sans 3` for sharp body text.
- **Unified Dialogs** - Consistent 320px width across all informational and account screens.
- **Image Preview** - Tap any relic to see its full-size visual.
- **Wiki & Market Integration** - Instant links to Warframe Wiki and warframe.market.

## Screenshots

| Home Screen | Relic Counter | Stats Dialog |
|-------------|---------------|--------------|
| ![Home](https://via.placeholder.com/200x400?text=Home) | ![Counter](https://via.placeholder.com/200x400?text=Counter) | ![Stats](https://via.placeholder.com/300x200?text=Stats) |

## Getting Started

### Prerequisites

- Flutter 3.27.0 or higher
- Dart 3.6.0 or higher
- PocketBase (optional, for cloud sync)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/warframetools.git
   cd warframetools
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

### Building for Production

**Linux (Desktop)**
```bash
flutter build linux
```

**Android**
```bash
flutter build apk --debug
```

**Web**
```bash
flutter build web
```

## PocketBase Setup (Optional)

Cloud sync is optional. The app works completely offline with bundled data.

For cloud sync functionality, you'll need a PocketBase instance running:

1. **Run PocketBase in Docker**
   ```bash
   docker run -d --name pocketbase -p 8090:8090 pocketbase/pocketbase
   ```

2. **Create the collections**

   **relics_info** (read-only):
   - `gid` (text, unique)
   - `name` (text)
   - `imageUrl` (text)
   - `type` (text)
   - `unvaulted` (bool)

   **avatars** (read-only):
   - `name` (text)
   - `imageUrl` (text)

   **users** (system collection):
   - `email` (text)
   - `username` (text)
   - `avatarUrl` (text)
   - `relics_owned` (json)

3. **Configure the app**
   - Update `lib/core/services/pocketbase_service.dart` if using a different URL
   - On first launch, app loads from bundled `assets/data/relics.json`
   - Cloud sync only needed for backup/restore

## Usage

### Adding Relics
1. Find the relic in the list
2. Tap the number to increment the count
3. Tap the minus button below to decrement

### Filtering
- **Inventory** - Shows all relics you own (with count > 0)
- **All** - Shows all relics
- **Type chips** - Filter by relic tier (Lith, Meso, Neo, Axi, Requiem)

### Searching
Use the search bar to find relics by name or type.

### Viewing Stats
Tap the analytics icon to see detailed statistics of your collection.

### Syncing
Tap the cloud sync icon to push or pull data from the server.

## Project Structure

```
lib/
├── main.dart                    # App entry point + init
├── app.dart                     # Root widget
├── models/
│   └── relic_item.dart          # Relic data model
├── providers/
│   └── relic_provider.dart      # State management (RelicNotifier)
├── screens/
│   ├── home_screen.dart         # Home screen
│   └── relic_counter_screen.dart # Main inventory screen
├── widgets/
│   ├── common/                  # Shared widgets
│   └── relic/                   # Relic-specific widgets
├── router/
│   └── app_router.dart          # Routing
├── core/
│   ├── theme/                   # Theme definitions
│   ├── utils/                   # Storage service
│   └── services/
│       ├── local_db_service.dart   # sqlite3 operations
│       └── pocketbase_service.dart # Cloud sync (optional)
assets/
├── images/                      # App images
└── data/
    └── relics.json              # Bundled relic data (690 relics)
```

## Tech Stack

| Category | Technology |
|----------|------------|
| Framework | Flutter 3.27+ |
| State Management | Riverpod 3.2.0 |
| Routing | GoRouter 14.x |
| Backend | PocketBase 0.23.2 (optional) |
| Local Storage | sqlite3 + Drift |
| Network Images | Cached Network Image |

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

Copyright © 2026 Omniversify. All rights reserved.

## Acknowledgments

- [Warframe Wiki](https://warframe.fandom.com/wiki/Warframe_Wiki) for relic data
- [PocketBase](https://pocketbase.io/) for the backend
- [Flutter Team](https://flutter.dev/) for the amazing framework

## Support

If you find this tool useful, consider supporting the development by:

- Reporting bugs
- Suggesting features
- Contributing code

---

*Happy farming, Tenno!*
