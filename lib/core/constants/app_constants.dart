class AppConstants {
  static const String ytsBaseUrl = 'https://yts.mx/api/v2';
  static const List<String> ytsApiMirrors = [
    'https://yts.mx/api/v2',
    'https://yts.am/api/v2',
    'https://yts.lt/api/v2',
    'https://yts.ag/api/v2',
  ];

  static String getPosterUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    return path;
  }

  static String getBackdropUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    return path;
  }

  static String getProfileUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    return path;
  }

  static const List<String> avatarAssets = [
    'assets/avatars/avatar1.png',
    'assets/avatars/avatar2.png',
    'assets/avatars/avatar3.png',
  ];
}
