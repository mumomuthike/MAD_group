# Budget Bytes
### *Eat well. Spend smart.*

College students often struggle to find affordable food options near campus while staying within their limited budgets. Food apps tend to focus  on restaurants in general but do not prioritize cost awareness, proximity to campus, or quick meal decisions between classes. Budget Bytes will help students quickly discover nearby food spots that match their budget, schedule, and personal preferences. The app will allow users to track their spending on meals, save all their favorite spots, and receive intuitive recommendations based on their mood, schedule, and budget.
---

## 👥 Team Members

| # | Name | Student ID | Role |
|---|------|------------|------|
| 1 | Mumo Musyoka | 002705763 | UI Design, Frontend, AI Integration |
| 2 | William Morgan | 002737412 | Business Logic, Database, AI Logic |

**Team Name:** Wumo  
**Repository:** [https://github.com/mumomuthike/MAD_group](https://github.com/mumomuthike/MAD_group)

---

## Features

### Food Discovery (Home Screen)
- Two restaurant lists: a horizontal "Near You" scroll (within 0.5 miles) and a full vertical "Browse by Vibe" list
- Filter by cuisine type (American, Mexican, Asian, Pizza, Healthy, Fast Food, Italian, Breakfast)
- Each restaurant row shows name, cuisine type, price range, distance in miles, and open hours
- Animated hero section with fade and slide-in transitions on load
- Weekly spending budget banner showing amount spent, amount remaining, and a color-coded progress bar (blue → gold at 75% → red when over)

### Restaurant Details
- Full restaurant profile: cuisine type, price range, hours, distance, and address
- Scrollable menu grouped by category (Breakfast, Lunch, Dinner, Drinks, Snack)
- Dietary info labels per menu item (Vegetarian, Vegan, None)
- Favorite toggle (heart button) with snackbar confirmation
- Cuisine-matched emoji and accent color per restaurant type

### Budget Tracker
- Set and track a weekly spending budget (Mon–Sun window)
- Add meal entries manually: name, cost, and date
- Visual progress bar with color feedback — blue (safe), gold (warning at 75%), red (over budget)
- Budget stat cards showing total budget and amount remaining
- Logged meals displayed as a scrollable list with meal name, date, cost, and a delete button
- Delete individual meal entries with a single tap
- Empty state prompt when no meals have been logged yet

### AI Meal Finder
- Budget slider ($5–$30) and time-available slider (10–60 min)
- Open text field for mood or craving description
- Filters restaurants by price range and walking distance based on slider values
- Sorts results by proximity and price, returning up to 5 ranked matches
- Top pick displayed as a prominent card; remaining matches shown as list tiles
- Snackbar error if no restaurants match the selected criteria

### Favorites (Saved Places)
- View all saved meals with restaurant name, price, personal rating, and save date
- Cuisine emoji and accent color per saved entry
- Tap any card to navigate directly to that restaurant's details
- Heart icon button is present per card
- Empty state shown when nothing has been saved yet

### Settings
- Edit user name, weekly budget, and dietary preferences
- Toggle notifications (meal reminders and budget alerts)
- Toggle budget-friendly-first mode (prioritizes cheaper restaurants)
- Clear all local app data with a confirmation dialog
- Save button persists changes with snackbar confirmation

### Theme & Design
- Custom color palette: primary blue (`#057EE6`), error red (`#BC1823`), gold accent (`#EEBA2B`)
- Three custom Google Fonts: **Sour Gummy** (display/headings), **Fresca** (body/UI), **Caveat** (accents/price tags)
- Cuisine-matched accent colors per restaurant type
- Material 3 design system throughout
- Animated splash screen with fade + scale transition and error/retry state

---

## Technologies Used

### Framework
- **Flutter** (Dart) — cross-platform mobile UI framework

### Packages

| Package | Purpose |
|---------|---------|
| `sqflite` | Local SQLite database for all persistent data |
| `path` | File path construction for the database file location |
| `shared_preferences` | Persisting theme, budget, and user preferences across sessions |
| `google_fonts` | Sour Gummy, Fresca, and Caveat typefaces |
| `flutter/material.dart` | Material 3 UI components (included in Flutter SDK) |

### Tools
- **Android Studio / VS Code** — development environment
- **Flutter DevTools** — debugging and performance profiling
- **Git / GitHub** — version control and collaboration

---

## Installation Instructions

### Prerequisites

Make sure the following are installed before you begin:

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel recommended)
- [Dart](https://dart.dev/get-dart) — included with Flutter
- [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/) with the Flutter and Dart extensions installed
- An Android emulator, iOS simulator, or a physical device connected via USB

### 1. Clone the Repository

```bash
git clone https://github.com/mumomuthike/MAD_group.git
cd MAD_group
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Verify Your Setup

```bash
flutter doctor
```

Resolve any issues flagged before continuing.

### 4. Run the App

```bash
flutter run
```

To target a specific device:

```bash
flutter devices          # list connected devices
flutter run -d <device_id>
```

### 5. Build for Release (optional)

```bash
# Android APK
flutter build apk --release

# iOS (requires macOS + Xcode)
flutter build ios --release
```

---

## Usage Guide

### Splash Screen
The app opens with an animated logo. After a 2-second initialization delay it navigates automatically to the Home screen. If something goes wrong during startup, an error message appears with a **Retry** button.

---

### Home Screen
The main screen loads nearby restaurants (within 0.5 miles) and displays your weekly spending summary at the top.

- Use the **cuisine filter chips** to narrow results by food type
- Tap any **restaurant card** to open its full details page
- The header shows current week's spending at a glance
- The **bottom navigation bar** provides access to Discover, Budget, Saved, and AI Pick
- The person icon in the top-right app bar navigates to Settings

---

### Restaurant Details
Tap any restaurant card from the Home screen or AI Finder to open this screen.

- View cuisine type, price range (\$, \$\$, \$\$\$), hours, distance, and address
- Scroll through the **menu** to see items, prices, categories, and dietary info
- Tap the **heart icon** in the app bar to toggle the restaurant as a favorite
- Tap **back** to return to the previous screen

---

### Budget Tracker
Access via the bottom navigation bar.

- The top banner shows your **weekly budget**, how much you've **spent**, and a color-coded progress bar
- Tap **Add Meal** (or the floating + button) to log a meal — enter a name, cost, and date
- All entries appear below, sorted most-recent first
- Tap the **trash icon** on any entry to remove it
- The progress bar turns **gold** at 75% spent and **red** when over budget

---

### AI Meal Finder
Access via the bottom navigation bar.

1. Type your **mood or craving** in the text field (e.g., *"cheap and filling for a 30 min break"*)
2. Adjust the **Budget slider** to set your max meal price ($5–$30)
3. Adjust the **Time Available slider** to set how many minutes you have (10–60 min)
4. Tap **Find My Meal**
5. Your **top pick** appears as a featured card — tap **View Details** to open it
6. Additional matches appear below as a ranked list

> If no restaurants match your filters, a snackbar will prompt you to adjust your budget or time.

---

### Favorites
Access via the bottom navigation bar.

- All saved meals are listed with restaurant name, price, personal rating, and save date
- Tap any card to navigate to that restaurant's full details
- Tap the **heart icon** on a card to remove it from favorites

> If nothing is saved yet, you'll see: *"Nothing saved yet. Tap ♥ on any restaurant."*

---

### Settings
Access via the bottom navigation bar.

| Setting | Description |
|---------|-------------|
| Name | Your display name |
| Weekly Budget | Your spending limit for the week |
| Dietary Preferences | Free-text field (e.g., Vegetarian, halal, no dairy) |
| Notifications | Toggle meal reminders and budget alerts on/off |
| Budget-friendly first | Prioritizes cheaper restaurants in listings |
| Save | Saves all changes |
| Clear My Data | Wipes all local app data (requires confirmation) |

---

## Database Schema

The app uses a local **SQLite** database (`budget_bytes.db`) stored on the device. It is created on first launch and foreign key constraints are enforced on every connection.

### `users`
| Column | Type | Notes |
|--------|------|-------|
| `user_id` | INTEGER PK | Auto-increment |
| `name` | TEXT | Not null |
| `campus` | TEXT | Not null |
| `weekly_budget` | REAL | Default 50.0 |
| `dietary_preferences` | TEXT | Default 'No preference' |

### `restaurants`
| Column | Type | Notes |
|--------|------|-------|
| `restaurant_id` | INTEGER PK | Auto-increment |
| `name` | TEXT | Not null |
| `cuisine_type` | TEXT | Not null |
| `address` | TEXT | Not null |
| `price_range` | INTEGER | 1 = $, 2 = $$, 3 = $$$ |
| `open_hours` | TEXT | e.g. "8:00 AM – 9:00 PM" |
| `distance_from_campus` | REAL | In miles |

### `menu_items`
| Column | Type | Notes |
|--------|------|-------|
| `item_id` | INTEGER PK | Auto-increment |
| `restaurant_id` | INTEGER FK | → `restaurants`, CASCADE DELETE |
| `name` | TEXT | Not null |
| `price` | REAL | Not null |
| `category` | TEXT | e.g. Breakfast, Lunch, Drinks |
| `dietary_info` | TEXT | Default 'None' |

### `budget_tracker`
| Column | Type | Notes |
|--------|------|-------|
| `entry_id` | INTEGER PK | Auto-increment |
| `user_id` | INTEGER FK | → `users`, CASCADE DELETE |
| `meal_name` | TEXT | Not null |
| `cost` | REAL | Not null |
| `restaurant_id` | INTEGER FK | → `restaurants`, SET NULL on delete (nullable) |
| `date` | TEXT | Format: "YYYY-MM-DD" |

### `saved_meals`
| Column | Type | Notes |
|--------|------|-------|
| `save_id` | INTEGER PK | Auto-increment |
| `user_id` | INTEGER FK | → `users`, CASCADE DELETE |
| `restaurant_id` | INTEGER FK | → `restaurants`, CASCADE DELETE |
| `meal_name` | TEXT | Not null |
| `price` | REAL | Not null |
| `personal_rating` | REAL | 0.0–5.0, default 0.0 |
| `save_date` | TEXT | Format: "YYYY-MM-DD" |

### `class_schedule`
| Column | Type | Notes |
|--------|------|-------|
| `class_id` | INTEGER PK | Auto-increment |
| `user_id` | INTEGER FK | → `users`, CASCADE DELETE |
| `class_name` | TEXT | Not null |
| `location` | TEXT | Not null |
| `days_of_week` | TEXT | e.g. "Mon,Wed,Fri" |
| `start_time` | TEXT | e.g. "09:00" |
| `end_time` | TEXT | e.g. "10:15" |

### `ai_meal_suggestions`
| Column | Type | Notes |
|--------|------|-------|
| `suggestion_id` | INTEGER PK | Auto-increment |
| `user_id` | INTEGER FK | → `users`, CASCADE DELETE |
| `restaurant_id` | INTEGER FK | → `restaurants`, CASCADE DELETE |
| `item_id` | INTEGER FK | → `menu_items`, SET NULL on delete (nullable) |
| `mood` | TEXT | Not null |
| `budget` | REAL | Not null |
| `time_available` | INTEGER | Minutes available between classes |
| `rank` | INTEGER | 1 = top pick |

**Seed data** is inserted on first launch: 9 restaurants and 27 menu items spanning American, Mexican, Asian, Pizza, Healthy, Fast Food, Italian, and Breakfast cuisine types, with distances ranging from 0.1 to 0.9 miles.

---

## Known Issues

- **No real authentication** — the app hardcodes `userId: 1`. A proper onboarding and login flow has not been implemented yet.
- **Favorites delete is stubbed** — tapping the remove button on the Favorites screen shows a placeholder snackbar but does not yet call a delete function on the database.
- **No real-time location** — restaurant distances are seeded statically; there is no live GPS or open/closed time detection.
- **AI logic is local only** — the AI Meal Finder uses price range and distance math to filter results; it does not call an external AI API or use the class schedule data yet.
---

## Future Enhancements

- **User onboarding** — collect name, campus, budget, and dietary preferences on first launch to create a real user record
- **Live location** — use device GPS to calculate actual walking distance instead of static seeded values
- **Open/closed detection** — parse `open_hours` strings against the device clock to show real-time open status on restaurant cards
- **Class schedule manager** — full UI for adding and editing classes, with the AI Meal Finder using the gap time between classes to refine suggestions
- **External AI integration** — connect the AI Meal Finder to a real language model API for natural language understanding of mood and craving inputs
- **Push notifications** — budget alerts when spending reaches 75% and 100% of the weekly limit
- **Restaurant photos** — support images loaded from local assets or a remote CDN
---

## License

```
MIT License

Copyright (c) 2026 Wumo (Mumo Musyoka, William Morgan)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```