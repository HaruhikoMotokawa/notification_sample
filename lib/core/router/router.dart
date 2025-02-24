import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notification_sample/presentations/screens/cat/screen.dart';
import 'package:notification_sample/presentations/screens/dog/screen.dart';
import 'package:notification_sample/presentations/screens/home/screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) => _goRouter;

final rootNavigatorKey = GlobalKey<NavigatorState>();

final _goRouter = GoRouter(
  // ルートナビゲーターのキー
  navigatorKey: rootNavigatorKey,
  // アプリが起動した時
  initialLocation: HomeScreen.path,
  // パスと画面の組み合わせ
  routes: [
    GoRoute(
      path: HomeScreen.path,
      name: HomeScreen.name,
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const HomeScreen(),
        );
      },
      routes: [
        GoRoute(
          path: DogScreen.path,
          name: DogScreen.name,
          pageBuilder: (context, state) {
            return MaterialPage(
              key: state.pageKey,
              child: const DogScreen(),
            );
          },
        ),
        GoRoute(
          path: CatScreen.path,
          name: CatScreen.name,
          pageBuilder: (context, state) {
            return MaterialPage(
              key: state.pageKey,
              child: const CatScreen(),
            );
          },
        ),
      ],
    ),
  ],
  // 遷移ページがないなどのエラーが発生した時に、このページに行く
  errorPageBuilder: (context, state) => MaterialPage(
    key: state.pageKey,
    child: Scaffold(
      body: Center(
        child: Text(state.error.toString()),
      ),
    ),
  ),
);
