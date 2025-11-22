class AppConstants {
  // YTS API Configuration (No API key required)
  static const String ytsBaseUrl = 'https://yts.lt/api/v2';

  // YTS API provides full image URLs, no need for base URL construction
  static String getPosterUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    return path; // YTS returns full URLs
  }

  static String getBackdropUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    return path; // YTS returns full URLs
  }

  static String getProfileUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    return path; // YTS returns full URLs
  }

  static const List<String> avatarAssets = [
    'assets/avatars/avatar1.png',
    'assets/avatars/avatar2.png',
    'assets/avatars/avatar3.png',
    'assets/avatars/avatar4.png',
    'assets/avatars/avatar5.png',
    'assets/avatars/avatar6.png',
    'assets/avatars/avatar7.png',
    'assets/avatars/avatar8.png',
    'assets/avatars/avatar9.png',
  ];
}
