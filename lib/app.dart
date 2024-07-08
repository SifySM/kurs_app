import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

class MyApp extends ConsumerWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentAppTheme = ref.watch(currentAppThemeNotifierProvider);
    return AppRoot(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: appName,
        theme: themeData(
          currentAppTheme.value == CurrentAppTheme.dark ? darkTheme : lightTheme,
        ),
        darkTheme: themeData(darkTheme),
        themeMode: currentAppTheme.value?.themeMode,
        routerConfig: _appRouter.config(
          navigatorObservers: () => [
            LogmanNavigatorObserver(),
          ],
        ),
      ),
    );
  }

  // Apply font to our app's theme
  ThemeData themeData(ThemeData theme) {
    return theme.copyWith(
      textTheme: GoogleFonts.sourceSansProTextTheme(
        theme.textTheme,
      ),
      colorScheme: theme.colorScheme.copyWith(
        secondary: lightAccent,
      ),
    );
  }
}