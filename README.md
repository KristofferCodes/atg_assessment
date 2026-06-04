# ATG IVF — Flutter Assessment
### Smartrob Technologies · Flutter Developer Assessment

A production-ready Flutter mobile application for ATG IVF Centre & Fertility Labs. Built as part of the Smartrob Technologies Flutter Developer Assessment, demonstrating clean architecture, Riverpod state management, Dio API integration, full light/dark theming, and a polished pixel-perfect UI.

---

## APK Download

> Download and install the release APK directly from GitHub Releases:
> **[Download ATG IVF v1.0.0 APK →](https://github.com/KristofferCodes/atg_assessment/releases/tag/v1.0.0)**

---

## Features Implemented

### Splash Screen
- Animated logo entry with elastic scale spring using `Curves.elasticOut`
- Tagline fade-in sequenced after logo lands
- Reads `SharedPreferences` on load and routes automatically:
  - First launch, no theme chosen → Theme Selection
  - First launch, theme chosen → Onboarding
  - Returning user → Login

### Theme Selection Screen *(beyond assessment scope — added for UX completeness)*
- Shown once on first launch, before onboarding
- User picks Light or Dark mode
- Selection persisted immediately to `SharedPreferences`
- App-wide `ThemeMode` updates instantly via Riverpod

### Onboarding Flow (3 screens)
- Full-bleed image per page occupying top 52% of screen
- White gradient fade at the bottom of each image blending into the content area
- Per-screen title and subtitle text
- Page indicator (uniform 10px dots, red active state) sits directly below body text
- Back arrow (left) and Next arrow (right) — back hidden on first page
- "Get Started →" pill button with image icon on final page
- Skip button (top-right, white) on pages 1 and 2
- `onboarding_done` flag persisted — shown only once per install
- `PageController` shared between screen and page widgets so indicator stays in sync

### Login Screen
- `×` close button top-left returns to onboarding
- Email and password fields with floating label, underline-only border
- Password show/hide toggle
- Forgot Password link (red, right-aligned)
- Form validation:
  - Email: required + regex format check
  - Password: required + minimum 6 characters
  - Errors appear inline below each field
- Login button animates from muted gold/tan (empty fields) to full red (both fields filled) — `AnimatedContainer` color transition
- Loading spinner replaces button label during API call
- Inline red error banner appears above fields on API failure
- On success: navigates to Home

### Login API Integration
- Real HTTP `POST` to `https://atg.smartrobtech.com/api/auth/login`
- Token extracted from `access_token` field and stored in `FlutterSecureStorage`
- Typed error handling at every layer (see Error Handling section)
- `Either<Failure, T>` pattern (via `dartz`) propagates errors cleanly from data → domain → presentation

### Home Screen
- Animated welcome screen post-login
- Elastic check icon bounce-in with ripple ring expansion and continuous pulse
- Staggered slide-up animations: check → title → subtitle → feature cards
- Floating particle system (18 dots) drifting upward in background
- Greets user by first name from API response (`first_name` field), falls back to "Chief"
- Three feature preview cards: Appointments, Lab Results, Messages
- Theme toggle and logout in AppBar

---

## Tech Stack

| Package | Version | Purpose |
|---|---|---|
| `flutter` | 3.44.1 | UI framework |
| `flutter_riverpod` | ^2.5.1 | State management |
| `go_router` | ^13.2.4 | Declarative navigation |
| `dio` | ^5.4.3 | HTTP client |
| `pretty_dio_logger` | ^1.3.1 | Network request logging |
| `flutter_secure_storage` | ^9.0.0 | Secure token storage |
| `shared_preferences` | ^2.2.3 | Onboarding + theme persistence |
| `google_fonts` | ^6.2.1 | Manrope font |
| `smooth_page_indicator` | ^1.1.0 | Onboarding dot indicator |
| `dartz` | ^0.10.1 | Functional `Either` error handling |
| `equatable` | ^2.0.5 | Value equality for entities/states |
| `freezed_annotation` | ^2.4.1 | Immutable model generation |
| `json_annotation` | ^4.9.0 | JSON serialization |

---

## Project Structure

```
lib/
├── main.dart                                    # Entry point — ProviderScope, SharedPrefs init
│
├── core/
│   ├── constants/
│   │   ├── app_constants.dart                   # Base URL, storage keys, durations
│   │   └── app_strings.dart                     # All UI copy (single source of truth)
│   ├── errors/
│   │   ├── exceptions.dart                      # ServerException, NetworkException, etc.
│   │   └── failures.dart                        # Failure types for Either pattern
│   ├── network/
│   │   └── dio_client.dart                      # Dio factory + AuthInterceptor + logger
│   ├── router/
│   │   ├── app_router.dart                      # GoRouter + custom slide/fade transitions
│   │   └── app_routes.dart                      # Route path constants
│   ├── theme/
│   │   ├── app_colors.dart                      # Full brand + semantic color palette
│   │   ├── app_text_styles.dart                 # Manrope typography scale
│   │   ├── app_theme.dart                       # Light + Dark ThemeData (Material 3)
│   │   └── theme_provider.dart                  # ThemeModeNotifier (Riverpod)
│   └── widgets/
│       ├── app_button.dart                      # Reusable button: primary/outline/ghost
│       └── app_text_field.dart                  # Labeled input with password toggle
│
└── features/
    ├── splash/
    │   └── presentation/
    │       └── screens/
    │           └── splash_screen.dart           # Animated logo + routing logic
    │
    ├── onboarding/
    │   └── presentation/
    │       ├── controllers/
    │       │   └── onboarding_controller.dart   # StateNotifier: current page index
    │       ├── screens/
    │       │   ├── theme_selection_screen.dart  # Light/dark picker (first launch)
    │       │   └── onboarding_screen.dart       # PageView + nav controls
    │       └── widgets/
    │           └── onboarding_page_widget.dart  # Image + gradient + text + indicator
    │
    └── auth/
        ├── data/
        │   ├── datasources/
        │   │   ├── auth_remote_datasource.dart  # Dio POST /api/auth/login
        │   │   └── auth_local_datasource.dart   # FlutterSecureStorage read/write/clear
        │   ├── models/
        │   │   └── user_model.dart              # JSON DTO + .toEntity() mapping
        │   └── repositories/
        │       └── auth_repository_impl.dart    # Implements domain contract
        ├── domain/
        │   ├── entities/
        │   │   └── user_entity.dart             # Pure Dart user model (no Flutter deps)
        │   ├── repositories/
        │   │   └── auth_repository.dart         # Abstract contract
        │   └── usecases/
        │       └── login_usecase.dart           # Single-responsibility login operation
        └── presentation/
            ├── controllers/
            │   ├── auth_providers.dart          # Full Riverpod provider dependency chain
            │   └── login_controller.dart        # StateNotifier: idle/loading/success/failure
            ├── screens/
            │   ├── login_screen.dart            # Login UI with all button/field states
            │   └── home_placeholder_screen.dart # Animated post-login welcome screen
            └── widgets/
                └── login_error_banner.dart      # Inline API error display
```

---

## Setup Instructions

### Prerequisites

- Flutter SDK `≥ 3.3.0` (tested on `3.44.1`)
- Dart `≥ 3.3.0`
- Android Studio or VS Code with Flutter/Dart extensions
- Android emulator or physical Android device

### Run the app

```bash
# 1. Clone
git clone https://github.com/KristofferCodes/atg_assessment.git
cd atg_assessment

# 2. Install dependencies
flutter pub get

# 3. Generate code (user_model.g.dart)
dart run build_runner build --delete-conflicting-outputs

# 4. Run
flutter run
```

### Test Credentials

```
Email:    samody2006@gmail.com
Password: password
```

---

## Architecture Explanation

This project follows **Clean Architecture** strictly, with three layers per feature. Dependencies only ever point inward — presentation depends on domain, data depends on domain, nothing depends on presentation.

```
┌─────────────────────────────────────┐
│         Presentation Layer          │  Flutter widgets, Riverpod StateNotifiers
│   screens / controllers / widgets   │  No business logic lives here
└────────────────┬────────────────────┘
                 │ calls
┌────────────────▼────────────────────┐
│           Domain Layer              │  Pure Dart — zero Flutter imports
│  entities / repositories / usecases │  Defines contracts, not implementations
└────────────────┬────────────────────┘
                 │ implemented by
┌────────────────▼────────────────────┐
│            Data Layer               │  Dio, SecureStorage, JSON models
│  datasources / models / repo impls  │  Maps external data to domain entities
└─────────────────────────────────────┘
```

### State Management — Riverpod MVC

Each feature follows a strict MVC separation within Riverpod:

- **Model** → Domain entities + data models (`UserEntity`, `UserModel`)
- **View** → Screens and widgets that only watch/read providers
- **Controller** → `StateNotifier` classes that hold and mutate state

The provider dependency chain for auth flows unidirectionally:

```
flutterSecureStorageProvider
  └─ dioClientProvider
       └─ authRemoteDatasourceProvider
            └─ authLocalDatasourceProvider
                 └─ authRepositoryProvider
                      └─ loginUsecaseProvider
                           └─ loginControllerProvider (StateNotifier<LoginState>)
                                └─ LoginScreen (watches/listens)
```

### Error Handling — Either Pattern

Errors flow through the stack without exceptions crossing layer boundaries:

```
DioException (data layer)
  → caught in AuthRemoteDatasourceImpl
    → rethrown as typed Exception (NetworkException, UnauthorizedException, etc.)
      → caught in AuthRepositoryImpl
        → mapped to typed Failure (NetworkFailure, UnauthorizedFailure, etc.)
          → returned as Left(failure) via Either<Failure, UserEntity>
            → LoginController maps to LoginState.failure(message)
              → LoginScreen displays inline error banner
```

This means no `try/catch` in the UI layer. The screen only checks `loginState.isFailure`.

---

## API Integration Details

### Endpoint

```
POST https://atg.smartrobtech.com/api/auth/login
Content-Type: application/json
```

### Request Body

```json
{
  "email": "samody2006@gmail.com",
  "password": "password"
}
```

### Success Response (200)

```json
{
  "message": "Login successful.",
  "access_token": "<bearer_token>",
  "token_type": "Bearer",
  "user": {
    "id": 11,
    "first_name": "Samsung",
    "last_name": "Ochuko",
    "name": "Samsung Ochuko",
    "email": "samody2006@gmail.com"
  }
}
```

The `access_token` field (not `token`) is extracted and stored in `FlutterSecureStorage`. The `first_name` field is used to personalise the home screen greeting.

### Error Response (401)

```json
{
  "message": "Invalid credentials."
}
```

### Error Handling Matrix

| Scenario | Exception | Failure | UI Message |
|---|---|---|---|
| No internet / connection refused | `NetworkException` | `NetworkFailure` | "No internet connection. Please try again." |
| Request / receive timeout | `NetworkException` | `NetworkFailure` | "Request timed out. Please try again." |
| HTTP 401 / 422 | `UnauthorizedException` | `UnauthorizedFailure` | "Invalid credentials. Please try again." |
| HTTP 5xx | `ServerException` | `ServerFailure` | Server message or generic fallback |
| Token storage failure | `CacheException` | `CacheFailure` | Handled silently, login still succeeds |

### Dio Client

The `DioClient` wraps Dio with:
- `BaseOptions`: base URL, 30s connect/receive timeouts, JSON headers
- `AuthInterceptor`: reads token from `FlutterSecureStorage` and attaches `Authorization: Bearer <token>` header automatically on every request
- `PrettyDioLogger`: logs request/response details in debug mode

---

## Design Decisions & Assumptions

1. **`FlutterSecureStorage` over `SharedPreferences` for the token** — tokens are sensitive credentials. `FlutterSecureStorage` uses Android Keystore and iOS Keychain, which is the correct level of protection for a healthcare app handling patient data.

2. **`Either<Failure, T>` pattern via `dartz`** — failures are explicit return values, not exceptions. This forces every error path to be handled at compile time and keeps the UI layer completely decoupled from data-layer exception types.

3. **Theme selection screen before onboarding** — a healthcare app used by patients of varying ages benefits from letting users set their comfort preference immediately. This is stored in `SharedPreferences` and applied before any other screen renders.

4. **`access_token` key confirmed by probing the live API** — the response uses `access_token` (not `token`). The datasource checks both keys as a defensive fallback in case the API shape changes.

5. **Manrope font** — specified in the Figma design. Applied globally via `GoogleFonts.manropeTextTheme()` so it cascades through all `TextTheme` slots without per-widget overrides.

6. **Onboarding page indicator lives inside the page widget, not the bottom bar** — this matches the Figma design exactly, where the dots appear directly below the body text rather than floating at the bottom of the screen.

7. **Onboarding shown once** — `onboarding_done` flag in `SharedPreferences`. Cleared only if the app is uninstalled or data is cleared.

8. **Home screen goes beyond placeholder** — the assessment only required a confirmation screen. The submitted version includes a fully animated welcome screen with staggered entry animations, a floating particle system, personalised greeting, and feature preview cards.

9. **Forgot Password is present in UI but not implemented** — outside the assessment scope. The tap target exists and is ready for a route to be wired in.

10. **No server-side token validation on launch** — the stored token is treated as valid if present. A production implementation would validate it against a `/me` endpoint.

---

## What Goes Beyond the Assessment Requirements

| Requirement | Status | What was added |
|---|---|---|
| Onboarding flow | ✅ | + Theme selection screen before onboarding |
| Login screen | ✅ | + Inline error banner, animated button, field-level validation |
| Login API integration | ✅ | + `Either` pattern, `FlutterSecureStorage`, typed failure chain |
| Clean architecture | ✅ | + `dartz` Either, strict layer separation, no cross-layer exceptions |
| Riverpod state management | ✅ | + Full unidirectional provider chain, MVC separation |
| Dio networking | ✅ | + Auth interceptor, PrettyDioLogger, timeout config |
| README | ✅ | + API response shape, error matrix, architecture diagrams |
| — | ➕ | Light/dark mode with user-selectable theme |
| — | ➕ | Animated home screen with particles and personalised greeting |
| — | ➕ | `FlutterSecureStorage` for token (more secure than SharedPreferences) |