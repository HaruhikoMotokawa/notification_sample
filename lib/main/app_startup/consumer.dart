import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notification_sample/main/app_startup/provider.dart';

/// 初期化を待つためのウィジェット
class AppStartupConsumer extends ConsumerWidget {
  const AppStartupConsumer({
    required this.onLoaded,
    required this.onLoading,
    required this.onError,
    super.key,
  });
  final Widget Function() onLoaded;
  final Widget Function() onLoading;
  final Widget Function(
    Object,
    StackTrace, {
    required VoidCallback onRestart,
  }) onError;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStartupState = ref.watch(appStartupProvider);
    return appStartupState.when(
      skipLoadingOnRefresh: false,
      data: (_) => onLoaded(),
      loading: onLoading,
      error: (e, s) =>
          onError(e, s, onRestart: () => ref.invalidate(appStartupProvider)),
    );
  }
}
