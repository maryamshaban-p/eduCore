import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ThemeCubit() : super(const ThemeState(isDark: false)) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final saved = await _storage.read(key: 'theme');
    emit(ThemeState(isDark: saved == 'dark'));
  }

  Future<void> toggleTheme() async {
    final isDark = !state.isDark;
    await _storage.write(key: 'theme', value: isDark ? 'dark' : 'light');
    emit(ThemeState(isDark: isDark));
  }
}