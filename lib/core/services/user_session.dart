/// Singleton that holds the currently authenticated user's data.
/// Populated after a successful login and cleared on logout.
///
/// All members are exposed as static getters so the rest of the app
/// can write `UserSession.fullName` / `UserSession.role` instead of
/// `UserSession.instance.fullName` — matching the call-sites in the
/// existing dashboard screens.
class UserSession {
  UserSession._();
  static final UserSession _i = UserSession._();

  String? _token;
  String? _userId;
  String? _role;
  String? _firstName;
  String? _lastName;
  String? _email;

  // ── Static accessors ────────────────────────────────────────────────
  static String get token      => _i._token      ?? '';
  static String get userId     => _i._userId     ?? '';
  static String get role       => _i._role       ?? '';
  static String get firstName  => _i._firstName  ?? '';
  static String get lastName   => _i._lastName   ?? '';
  static String get email      => _i._email      ?? '';

  static String get fullName {
    final name = '${_i._firstName ?? ''} ${_i._lastName ?? ''}'.trim();
    return name;
  }

  static bool get isAuthenticated =>
      _i._token != null && _i._token!.isNotEmpty;

  // ── Helpers ──────────────────────────────────────────────────────────
  /// Returns up to two uppercase initials from [name].
  /// e.g. "selim mohamed" → "SM", "selim" → "S", "" → "?"
  static String getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts[0].isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  // ── Internal mutators (used by AuthService only) ─────────────────────
  static void save(Map<String, dynamic> json) {
    _i._token     = json['token']     as String?;
    _i._userId    = json['userId'] ?? json['id'] as String?;
    _i._role      = json['role']      as String?;
    _i._firstName = json['firstname'] as String?;
    _i._lastName  = json['lastname']  as String?;
    _i._email     = json['email']     as String?;
  }

  static void clear() {
    _i._token     = null;
    _i._userId    = null;
    _i._role      = null;
    _i._firstName = null;
    _i._lastName  = null;
    _i._email     = null;
  }
}