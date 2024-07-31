class TokenManager {
  static String? accessToken;
  static String? refreshToken;
  static String? sub;

  static void setTokens(String access, String refresh, String sub) {
    accessToken = access;
    refreshToken = refresh;
    sub = sub;
    print('Tokens set. Session State: $sub');
  }

  static void clearTokens() {
    accessToken = null;
    refreshToken = null;
    sub = null;
    print('Tokens cleared.');
  }
}
