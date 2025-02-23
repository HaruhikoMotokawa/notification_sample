import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notification_sample/data/repositories/permission_handler/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@Riverpod(keepAlive: true)
PermissionHandlerRepositoryBase permissionHandlerRepository(Ref ref) =>
    PermissionHandlerRepository(ref);
