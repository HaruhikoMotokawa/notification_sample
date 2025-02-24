import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notification_sample/data/repositories/local_notification/provider.dart';
import 'package:notification_sample/data/repositories/permission_handler/provider.dart';
import 'package:notification_sample/presentations/screens/cat/screen.dart';
import 'package:notification_sample/presentations/screens/dog/screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({
    super.key,
  });

  static const name = 'HomeScreen';
  static const path = '/';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 20,
          children: [
            ElevatedButton(
              onPressed: () {
                ref.read(permissionHandlerRepositoryProvider).goAppSettings();
              },
              child: const Text('アプリの設定画面へ遷移'),
            ),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(localNotificationsRepositoryProvider)
                    .showNotification();
              },
              child: const Text('すぐに通知を送る'),
            ),
            ElevatedButton(
              onPressed: () async {
                final setDate = DateTime.now().add(const Duration(seconds: 5));
                await ref
                    .read(localNotificationsRepositoryProvider)
                    .zonedSchedule(
                      dateTime: setDate,
                    );
              },
              child: const Text('今から5秒後に通知を流す'
                  '\nAndroidはSCHEDULE_EXACT_ALARM が不要'),
            ),
            const Divider(),
            ElevatedButton(
              onPressed: () async {
                final setDate = DateTime.now().add(const Duration(seconds: 5));
                await ref
                    .read(localNotificationsRepositoryProvider)
                    .testZonedSchedule(
                      dateTime: setDate,
                      androidScheduleMode: AndroidScheduleMode.alarmClock,
                    );
              },
              child: const Text('今から5秒後に通知を飛ばす'
                  '\nAndroidはSCHEDULE_EXACT_ALARM が必要'),
            ),
            const Divider(),
            ElevatedButton(
              onPressed: () async {
                final setDate = DateTime.now().add(const Duration(seconds: 5));
                await ref
                    .read(localNotificationsRepositoryProvider)
                    .zonedSchedule(
                      dateTime: setDate,
                      payload: DogScreen.path,
                    );
              },
              child: const Text('DogScreenへ遷移する通知を5秒後に飛ばします'),
            ),
            ElevatedButton(
              onPressed: () async {
                final setDate = DateTime.now().add(const Duration(seconds: 5));
                await ref
                    .read(localNotificationsRepositoryProvider)
                    .zonedSchedule(
                      dateTime: setDate,
                      payload: CatScreen.path,
                    );
              },
              child: const Text('CatScreenへ遷移する通知を5秒後に飛ばします'),
            ),
            const Divider(),
            ElevatedButton(
              onPressed: () => context.go(DogScreen.path),
              child: const Text('DogScreenへ遷移'),
            ),
            ElevatedButton(
              onPressed: () => context.go(CatScreen.path),
              child: const Text('CatScreenへ遷移'),
            ),
          ],
        ),
      ),
    );
  }
}
