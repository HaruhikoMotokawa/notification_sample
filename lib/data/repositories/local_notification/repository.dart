import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notification_sample/core/log/logger.dart';
import 'package:notification_sample/core/router/router.dart';
import 'package:notification_sample/data/repositories/local_notification/provider.dart';
import 'package:notification_sample/data/sources/local/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

abstract interface class LocalNotificationsRepositoryBase {
  Future<void> init();

  /// 通知スケジュールに登録する
  ///
  /// [dateTime] 指定した日時で通知する
  Future<void> zonedSchedule({
    required DateTime dateTime,
    String? payload,
  });

  /// （検証用）通知スケジュールに登録する
  ///
  /// [dateTime] 指定した日時で通知する
  Future<void> testZonedSchedule({
    required DateTime dateTime,
    String? payload,
    AndroidScheduleMode androidScheduleMode,
    int? inputZonedScheduleId,
  });

  /// 即時実行型の通知を表示
  Future<void> showNotification();

  /// 現在予定されている通知を取得
  Future<List<PendingNotificationRequest>> getPendingNotificationRequests();
}

class LocalNotificationsRepository implements LocalNotificationsRepositoryBase {
  LocalNotificationsRepository(this.ref);
  final Ref ref;

  FlutterLocalNotificationsPlugin get localNotifications =>
      ref.read(localNotificationsProvider);

  static const _channelId = 'default_notification_channel';
  static const _channelName = 'プッシュ通知';
  static const _channelDescription = 'Notification Sampleからのプッシュ通知';
  static const _androidAppIcon = '@mipmap/ic_launcher';

  static const initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings(_androidAppIcon),
    iOS: DarwinInitializationSettings(),
  );

  static const _androidNotificationDetails = AndroidNotificationDetails(
    _channelId,
    _channelName,
    channelDescription: _channelDescription,
    importance: Importance.max,
    priority: Priority.high,
  );

  @override
  Future<void> init() async {
    // タイムゾーンの初期化
    tz.initializeTimeZones();

    // ローカルから表示したプッシュ通知をタップした場合の処理を設定
    await localNotifications.initialize(
      // プッシュ通知の初期設定
      initializationSettings,
      // ローカルから表示したプッシュ通知をタップした場合の処理を設定
      onDidReceiveNotificationResponse: _handleNotificationTap,
    );

    // アプリがキルされた状態でプッシュ通知をタップした場合の処理を設定
    await _handleNotificationTapOnTerminated();
  }

  /// プッシュ通知をタップした際の処理
  ///
  /// 通知をタップした際にアプリを起動し、ペイロードに設定されたパスに遷移する
  static void _handleNotificationTap(NotificationResponse response) {
    final payload = response.payload;
    if (payload != null && payload.isNotEmpty) {
      final context = rootNavigatorKey.currentContext;
      // アプリが起動状態であれば基本的にはcontextは取得できる
      if (context != null) {
        // ペイロードに設定されたパスに遷移
        context.go(payload);
      } else {
        logger.w('Failed to get context');
      }
    }
  }

  // アプリキル状態で通知をタップした場合の処理
  Future<void> _handleNotificationTapOnTerminated() async {
    // アプリがキル状態で通知をタップした場合の詳細情報を取得
    final notificationAppLaunchDetails =
        await localNotifications.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails == null) return;

    final response = notificationAppLaunchDetails.notificationResponse;
    if (response == null) return;

    final payload = response.payload;
    if (payload != null && payload.isNotEmpty) {
      // ペイロードに設定されたパスを設定
      ref.read(notificationLocationProvider.notifier).path = payload;
    }
  }

  @override
  Future<void> zonedSchedule({
    required DateTime dateTime,
    String? payload,
  }) async {
    // ハッシュ化したものを通知IDに使用
    final zonedScheduleId = _hashTo32Bit(dateTime.toString());

    try {
      // 通知スケジュールに登録
      await localNotifications.zonedSchedule(
        zonedScheduleId,
        '通知',
        '$dateTimeになりました',
        // 指定日時に通知する
        tz.TZDateTime.from(dateTime, tz.local),
        const NotificationDetails(android: _androidNotificationDetails),
        // どのくらい正確に通知するかの設定
        androidScheduleMode: AndroidScheduleMode.inexact,
        // 壁紙時計の時間 == ユーザーのローカルタイムゾーン
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
        // プッシュ通知をタップしたときに情報を渡したい場合はここに記載する
        payload: payload,
      );
    } on Exception catch (e) {
      logger.w('Failed to schedule notification: $e');
    }
  }

  /// SHA-256を使って文字列を32ビットのハッシュに変換
  int _hashTo32Bit(String input) {
    // 文字列をバイト配列に変換
    final bytes = utf8.encode(input);
    // SHA-256 でハッシュ化
    final digest = sha256.convert(bytes);
    // SHA-256 の最初の 4 バイトを取得
    final hashBytes = digest.bytes.sublist(0, 4);
    // Uint8List に変換（バイト配列として扱う）
    final uint8List = Uint8List.fromList(hashBytes);
    // バイト配列をビッグエンディアンのバッファに変換
    final byteData = uint8List.buffer.asByteData();
    // 32ビットの符号付き整数に変換
    return byteData.getInt32(0);
  }

  @override
  Future<void> testZonedSchedule({
    required DateTime dateTime,
    String? payload,
    AndroidScheduleMode androidScheduleMode = AndroidScheduleMode.inexact,
    int? inputZonedScheduleId,
  }) async {
    // ハッシュ化したものを通知IDに使用
    // IDが同じものは上書きされる
    final zonedScheduleId =
        inputZonedScheduleId ?? _hashTo32Bit(dateTime.toString());

    try {
      await localNotifications.zonedSchedule(
        zonedScheduleId,
        'テスト用の通知',
        '$dateTimeになりました',
        tz.TZDateTime.from(dateTime, tz.local),
        const NotificationDetails(android: _androidNotificationDetails),
        // どのくらい正確に通知するかの設定
        androidScheduleMode: androidScheduleMode,

        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,

        payload: payload,
      );
    } on Exception catch (e) {
      logger.w('Failed to schedule notification: $e');
    }
  }

  @override
  Future<void> showNotification() => localNotifications.show(
        0,
        'plain title',
        'plain body',
        const NotificationDetails(android: _androidNotificationDetails),
      );

  @override
  Future<List<PendingNotificationRequest>> getPendingNotificationRequests() =>
      localNotifications.pendingNotificationRequests();
}
