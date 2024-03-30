import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:global_gallery/state/auth/providers/auth_state_provider.dart';
import 'package:global_gallery/state/auth/providers/is_logged_in_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.lightGreen,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepOrange,
      ),
      themeMode: ThemeMode.dark,
      home: Consumer(
        builder: (context, ref, child) {
          final isLoggedIn = ref.watch(isLoggedInProvider);
          if (isLoggedIn) {
            return const MainPage();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Global Gallery'),
      ),
      body: Consumer(
        builder: (_, ref, __) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text('you logged in'),
                ElevatedButton(
                  onPressed: () async {
                    ref.read(authStateProvider.notifier).logOut();
                  },
                  child: const Text('Logout!'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: ref.read(authStateProvider.notifier).loginWithGoogle,
              child: const Text('Sign in with google'),
            ),
            ElevatedButton(
              onPressed: ref.read(authStateProvider.notifier).loginWithFacebook,
              child: const Text('Sign in with facebook'),
            ),
          ],
        ),
      ),
    );
  }
}
