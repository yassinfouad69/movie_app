# Movie App Setup Guide

## Prerequisites
- Flutter SDK installed
- TMDB API Key (get it from https://www.themoviedb.org/settings/api)

## Setup Steps

### 1. Get TMDB API Key
1. Go to https://www.themoviedb.org/
2. Create an account or login
3. Go to Settings > API
4. Request an API key (choose "Developer")
5. Fill out the form and get your API key

### 2. Configure API Key
1. Open `lib/core/constants/app_constants.dart`
2. Replace `YOUR_TMDB_API_KEY_HERE` with your actual TMDB API key:
   ```dart
   static const String tmdbApiKey = 'your_actual_api_key_here';
   ```

### 3. Install Dependencies
```bash
flutter pub get
```

### 4. Run the App
```bash
flutter run
```

## Features Implemented

### Authentication
- ✅ Login Screen with email/password
- ✅ Register Screen with avatar selection
- ✅ Forgot Password Screen
- ✅ Update Profile Screen
- ✅ Google Sign-In integration
- ✅ Logout functionality

### Screens
- ✅ Splash Screen with app logo
- ✅ Onboarding Screens (5 pages)
- ✅ Home Screen with:
  - Movie slider for new releases
  - Random 3 categories (changes on each visit)
  - "See more" functionality for each category
- ✅ Search Screen (search by movie name or category)
- ✅ Browse Screen (filter by categories)
- ✅ Profile Screen with:
  - User avatar and info
  - Watchlist count and History count
  - Watchlist tab
  - History tab
  - Edit Profile button
  - Logout button
- ✅ Movie Details Screen with:
  - Movie poster/backdrop
  - Add/Remove from watchlist button
  - Watch button (redirects to Google search)
  - Favorites count, duration, rating
  - Movie description
  - Cast list
  - Genres
  - Screenshots
  - Similar movies

### State Management
- ✅ BLoC pattern for all state management
- ✅ AuthBloc for authentication
- ✅ MoviesBloc for movie data
- ✅ WatchlistBloc for watchlist and history

### Data Persistence
- ✅ Local storage using SharedPreferences
- ✅ User data persistence
- ✅ Watchlist persistence
- ✅ History tracking
- ✅ Onboarding completion tracking

### UI/UX
- ✅ Dark theme with yellow/gold accent
- ✅ Bottom navigation with 4 tabs
- ✅ Pull-to-refresh on home screen
- ✅ Smooth page indicators for onboarding
- ✅ Cached network images
- ✅ Loading states
- ✅ Error handling
- ✅ Empty states

## App Structure
```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   └── app_constants.dart
│   └── theme/
│       └── app_theme.dart
├── data/
│   ├── datasources/
│   │   ├── local_storage_service.dart
│   │   └── movie_api_service.dart
│   ├── models/
│   │   ├── cast_model.dart
│   │   ├── genre_model.dart
│   │   ├── movie_model.dart
│   │   └── user_model.dart
│   └── repositories/
│       ├── auth_repository.dart
│       └── movie_repository.dart
├── logic/
│   ├── auth/
│   │   ├── auth_bloc.dart
│   │   ├── auth_event.dart
│   │   └── auth_state.dart
│   ├── movies/
│   │   ├── movies_bloc.dart
│   │   ├── movies_event.dart
│   │   └── movies_state.dart
│   └── watchlist/
│       ├── watchlist_bloc.dart
│       ├── watchlist_event.dart
│       └── watchlist_state.dart
└── presentation/
    ├── screens/
    │   ├── auth/
    │   │   ├── forgot_password_screen.dart
    │   │   ├── login_screen.dart
    │   │   ├── register_screen.dart
    │   │   └── update_profile_screen.dart
    │   ├── browse/
    │   │   └── browse_screen.dart
    │   ├── home/
    │   │   ├── category_movies_screen.dart
    │   │   ├── home_screen.dart
    │   │   └── main_navigation.dart
    │   ├── movie_details/
    │   │   └── movie_details_screen.dart
    │   ├── onboarding/
    │   │   └── onboarding_screen.dart
    │   ├── profile/
    │   │   └── profile_screen.dart
    │   ├── search/
    │   │   └── search_screen.dart
    │   └── splash/
    │       └── splash_screen.dart
    └── widgets/
        └── movie/
            ├── movie_card.dart
            └── movie_grid_card.dart
```

## Notes
- The app uses TMDB API for all movie data
- Authentication is simulated locally (no backend)
- Google Sign-In is configured but requires Google Services setup for production
- The random category order changes each time you leave and return to the home screen
- History is automatically tracked when viewing movie details
- Watchlist can be toggled from the movie details screen

## Troubleshooting
- If movies don't load, check your API key in `app_constants.dart`
- If images don't show, ensure you have internet connection
- For Google Sign-In issues, configure Firebase/Google Services properly

Enjoy your movie app!
