class TokenManager {
  static String? accessToken;
  static String? refreshToken;
  static String? sessionState;

  static void setTokens(String access, String refresh, String session) {
    accessToken = access;
    refreshToken = refresh;
    sessionState = session;
    print('Tokens set. Session State: $sessionState');
  }

  static void clearTokens() {
    accessToken = null;
    refreshToken = null;
    sessionState = null;
    print('Tokens cleared.');
  }
}
