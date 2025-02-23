import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notification_sample/core/log/logger.dart';
import 'package:notification_sample/data/sources/local/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

abstract interface class LocalNotificationsRepositoryBase {
  Future<void> init();

  /// 通知スケジュールに登録
  ///
  /// [dateTime] 指定した日時で通知する
  Future<void> zonedSchedule({required DateTime dateTime});

  Future<void> showNotification();
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

  @override
  Future<void> init() async {
    // タイムゾーンの初期化
    tz.initializeTimeZones();

    if (defaultTargetPlatform == TargetPlatform.android) {
      // Androidのの通知設定
      final androidImplementation =
          localNotifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidImplementation?.createNotificationChannel(
        const AndroidNotificationChannel(
          _channelId,
          _channelName,
          importance: Importance.high,
        ),
      );
    }

    // ローカルから表示したプッシュ通知をタップした場合の処理を設定
    await localNotifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings(_androidAppIcon),
        iOS: DarwinInitializationSettings(),
      ),
      // プッシュ通知をタップした場合の処理を設定
      onDidReceiveBackgroundNotificationResponse: _handleNotificationTap,
      // ローカルから表示したプッシュ通知をタップした場合の処理を設定
      onDidReceiveNotificationResponse: _handleNotificationTap,
    );
  }

  /// プッシュ通知をタップした際の処理
  ///
  /// 通知をタップした際にアプリを起動し、ペイロードに設定されたパスに遷移する
  static void _handleNotificationTap(NotificationResponse response) {
    logger.d(response);
  }

  @override
  Future<void> zonedSchedule({required DateTime dateTime}) async {
    // ハッシュ化したものを通知IDに使用
    final zonedScheduleId = _hashTo32Bit(dateTime.toString());

    // 通知スケジュールに登録
    await localNotifications.zonedSchedule(
      zonedScheduleId,
      'アラーム',
      '$dateTimeになりました',
      // 予約作品の閲覧可能通知は、作品の閲覧可能日時に通知する
      tz.TZDateTime.from(dateTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      payload: 'payload',
      // 正確な時間で通知する
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      // 壁紙時計の時間 == ユーザーのローカルタイムゾーン
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
    );
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
  Future<void> showNotification() async {
    const androidNotificationDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await localNotifications.show(
      0,
      'plain title',
      'plain body',
      notificationDetails,
      payload: 'item x',
    );
  }
}
