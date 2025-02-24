import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notification_sample/data/repositories/local_notification/provider.dart';

class CatScreen extends HookConsumerWidget {
  const CatScreen({super.key});

  static const name = 'CatScreen';
  static const path = '/cat_screen';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 予定されている通知
    final pendingNotifications = useState(0);
    return Scaffold(
      appBar: AppBar(
        title: const Text('CatScreen'),
      ),
      body: Center(
        child: Column(
          spacing: 20,
          children: [
            Text(
              '予定されている通知： ${pendingNotifications.value}件',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            ElevatedButton(
              onPressed: () async {
                final list = await ref
                    .read(localNotificationsRepositoryProvider)
                    .getPendingNotificationRequests();
                pendingNotifications.value = list.length;
              },
              child: const Text('最新の通知予約を取得'),
            ),
            const Divider(),
            ElevatedButton(
              onPressed: () async {
                final setDate = DateTime.now().add(const Duration(minutes: 3));
                await ref
                    .read(localNotificationsRepositoryProvider)
                    .zonedSchedule(
                      dateTime: setDate,
                    );
              },
              child: const Text('３分後に通知を飛ばす'),
            ),
            ElevatedButton(
              onPressed: () async {
                final setDate = DateTime.now().add(const Duration(minutes: 3));
                await ref
                    .read(localNotificationsRepositoryProvider)
                    .testZonedSchedule(
                      dateTime: setDate,
                      inputZonedScheduleId: 1,
                    );
              },
              child: const Text('IDを固定で３分後に通知を飛ばす'),
            ),
          ],
        ),
      ),
    );
  }
}
