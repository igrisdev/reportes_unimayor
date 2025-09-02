import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:reportes_unimayor/config/themes/themes.dart';

part 'themes_provider.g.dart';

@riverpod
class ThemeController extends _$ThemeController {
  @override
  ThemeData build() {
    return AppTheme.lightTheme;
  }

  void toggleTheme() {
    if (state.brightness == Brightness.light) {
      state = AppTheme.darkTheme;
    } else {
      state = AppTheme.lightTheme;
    }
  }

  void setTheme(bool isDark) {
    state = isDark ? AppTheme.darkTheme : AppTheme.lightTheme;
  }
}
