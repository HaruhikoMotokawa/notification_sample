import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notification_sample/data/repositories/local_notification/provider.dart';
import 'package:notification_sample/data/repositories/permission_handler/provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@Riverpod(keepAlive: true)
Future<void> appStartup(Ref ref) async {
  // 権限のリクエスト
  await ref.read(permissionHandlerRepositoryProvider).requestPermission();

  // プッシュ通知の初期化
  await ref.read(localNotificationsRepositoryProvider).init();
}
