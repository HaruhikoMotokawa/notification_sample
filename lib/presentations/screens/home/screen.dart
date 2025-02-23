import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notification_sample/data/repositories/permission_handler/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  static const name = 'HomeScreen';
  static const path = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer(
          builder: (context, ref, child) {
            return ElevatedButton(
              onPressed: () {
                ref.read(permissionHandlerRepositoryProvider).goAppSettings();
              },
              child: const Text('Button'),
            );
          },
        ),
      ),
    );
  }
}
