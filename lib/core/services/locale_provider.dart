import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Current app locale. Toggle between English and Arabic for full RTL support.
final localeProvider = StateProvider<Locale>((ref) => const Locale('en'));

/// Toggles between English and Arabic.
void toggleLocale(WidgetRef ref) {
  final current = ref.read(localeProvider);
  ref.read(localeProvider.notifier).state =
      current.languageCode == 'en' ? const Locale('ar') : const Locale('en');
}

bool isArabic(Locale locale) => locale.languageCode == 'ar';
