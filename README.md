
# Flutter Calendar App

A fully featured Flutter calendar app with Firebase Authentication and Firestore integration. Users can sign in (including guest access), create, view, edit, and delete events. The app supports day/week/month views, event reminders, and a clean, easy-to-use interface.

---

## Features

- **Firebase Authentication** (email/password and guest sign-in)
- **Firestore** database for storing events securely
- **Month, Week, and Day calendar views** using `table_calendar`
- **Create, Read, Update, Delete (CRUD)** events per user
- **Event reminders with notifications**
- **Bottom Navigation Bar**: Calendar, Profile, My Events
- **Events sorted by start time**
- **Custom color labels for events**
- Responsive UI with loading indicators and error handling

---

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=2.18.0)
- Firebase project setup with Authentication and Firestore enabled

### Setup

1. **Clone the repo**

```bash
git clone https://github.com/DanielI22/FlutterExam.git
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Configure Firebase**

- Follow [Firebase Flutter Setup](https://firebase.flutter.dev/docs/overview) to create your Firebase project.
- Download `google-services.json` (Android) and/or `GoogleService-Info.plist` (iOS) and place them in the appropriate folders.
- Update `firebase_options.dart` with your Firebase config (if using FlutterFire CLI).

4. **Run the app**

```bash
flutter run
```

---

## Code Structure

- `/lib/models` — Data models (e.g., `CalendarEvent`)
- `/lib/services` — Firebase service wrappers (e.g., `EventService`, `NotificationService`)
- `/lib/screens` — UI screens (Calendar, My Events, Profile)
- `/lib/widgets` — Reusable widgets (e.g., `EventTile`)

---

## Usage

- Sign in with email or as a guest.
- Use the calendar view to navigate dates.
- Tap the "+" button to add a new event.
- View your events on the "My Events" tab.
- Edit or delete events as needed.
- Notifications remind you about upcoming events.

---

## Dependencies

- `firebase_core`
- `firebase_auth`
- `cloud_firestore`
- `table_calendar`
- `flutter_local_notifications`
- Others as specified in `pubspec.yaml`

---


## License

MIT License © 2025 Daniel Ivanov
