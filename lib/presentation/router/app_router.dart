import 'package:app_with_bloc/logic/cubit/stopwatch_cubit.dart';
import 'package:app_with_bloc/presentation/screens/settings_screen.dart';
import 'package:app_with_bloc/presentation/screens/stopwatch_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  static const String stopwatchRoute = '/';
  static const String settingsRoute = 'settings';

  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case stopwatchRoute:
        return _buildRoute(const StopwatchScreen());
      case settingsRoute:
        return _buildRoute(const SettingsScreen());
      default:
        return _buildRoute(const UnknownRouteScreen());
    }
  }

  MaterialPageRoute _buildRoute(Widget screen) {
    return MaterialPageRoute(
      builder: (context) {
        return BlocProvider(
          create: (_) => WatchCubit(),
          child: screen,
        );
      },
    );
  }
}

class UnknownRouteScreen extends StatelessWidget {
  const UnknownRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Page not Found'),
            SizedBox(height: 10),
            Text('The page you have entered does not exist.'),
          ],
        ),
      ),
    );
  }
}
