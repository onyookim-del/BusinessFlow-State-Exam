# BusinessFlow — State Examination Flutter Prototype

Internal staff-facing customer and booking management app for small travel service businesses.

## Run on Mac

1. Install Flutter SDK, Xcode tools or Chrome as appropriate.
2. Open this folder in VS Code or Android Studio.
3. Run `flutter pub get`.
4. Run `flutter analyze` and `flutter test`.
5. Run `flutter run -d chrome` (or select your emulator/device).

## Features

- Customer add/edit/delete/search; duplicate phone checks and validation.
- Booking add/edit/delete; date, time, service, price, staff and status.
- Dashboard, daily schedule, booking analytics.
- English/Korean/Russian interface labels.
- Local persistent JSON data using `shared_preferences`.
- Optional fictional sample records in Settings (only on an empty store).

## Important technical notes

This is a **single-device prototype**, not a deployed multi-user production system. Data is stored locally in app preferences, not a relational SQL database. No real customer data is bundled. Authentication and staff permissions are not implemented. The current state management is ChangeNotifier; the original lab's registration and localization concepts were adapted, but this release is **not BLoC-based**. The app was assembled without a Flutter SDK in the authoring environment; compilation must be verified on the student's Mac.

## Data sources

Demo records are synthetic, authored for this app. The Hotel Booking Demand dataset is **not included**. Possible future source: António, N., Almeida, A., & Nunes, L. (2019). Hotel booking demand datasets. Data in Brief, 22, 41–49. https://doi.org/10.1016/j.dib.2018.11.126

## Original project

Adapted from the user-provided `lab_7-main.zip` (original project structure, Flutter configuration and assets retained). The prior internship report describes the initial form-based prototype.
