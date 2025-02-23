import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'flutter_local_notifications.g.dart';

@riverpod
FlutterLocalNotificationsPlugin localNotifications(Ref ref) =>
    FlutterLocalNotificationsPlugin();
