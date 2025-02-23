import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notification_sample/core/constants/constants.dart';
import 'package:notification_sample/core/router/router.dart';
import 'package:notification_sample/presentations/theme/theme.dart';

/// アプリの基盤となるウィジェット
class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: Constants.appName,
      theme: createThemeData(Constants.baseSeedColor, Brightness.light),
      darkTheme: createThemeData(Constants.baseSeedColor, Brightness.dark),
      supportedLocales: const [Locale('ja')],
      locale: const Locale('ja'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: ref.read(routerProvider),
    );
  }
}
