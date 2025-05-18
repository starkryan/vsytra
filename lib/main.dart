import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:me_lond/providers/user_provider.dart';
import 'package:me_lond/providers/livestream_provider.dart';
import 'package:me_lond/utilities/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define custom darker rose theme for better contrast
    const darkRoseScheme = ShadRoseColorScheme.dark(
      background: Color(0xFF1A1A1A), // Darker background
      card: Color(0xFF262626), // Slightly lighter card background
      muted: Color(0xFF666666), // Lighter muted color for better readability
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => LivestreamProvider()),
      ],
      child: Builder(
        builder: (context) {
          final router = AppRouter.getRouter(context);

          return ShadApp.router(
            title: 'MeLond',
            theme: ShadThemeData(
              brightness: Brightness.light,
              colorScheme: const ShadRoseColorScheme.light(),
              textTheme: ShadTextTheme(family: null),
            ),
            darkTheme: ShadThemeData(
              brightness: Brightness.dark,
              colorScheme: darkRoseScheme,
              textTheme: ShadTextTheme(family: null),
            ),
            themeMode: ThemeMode.system,
            debugShowCheckedModeBanner: false,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
