import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notification_sample/core/log/logger.dart';
import 'package:permission_handler/permission_handler.dart';

abstract interface class PermissionHandlerRepositoryBase {
  /// 権限をリクエストする
  Future<void> requestPermission();
}

class PermissionHandlerRepository implements PermissionHandlerRepositoryBase {
  PermissionHandlerRepository(this.ref);
  final Ref ref;

  @override
  Future<void> requestPermission() async {
    /// 複数の権限をリクエストする場合は、以下のように記述する
    final status = [
      Permission.notification,

      /// Androidの場合のみ
      // if (defaultTargetPlatform == TargetPlatform.android) ...[
      //   // 厳密なアラームの設定権限 主にプッシュ通知のスケジュールで使用
      //   Permission.scheduleExactAlarm,
      // ],
    ];
    // 権限をリクエストする
    final result = await status.request();
    logger.d('Permission status: $result');
  }
}
