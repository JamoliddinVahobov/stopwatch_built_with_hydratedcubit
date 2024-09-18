import 'package:app_with_bloc/logic/cubit/stopwatch_cubit.dart';
import 'package:app_with_bloc/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  final WatchCubit _watchCubit = WatchCubit();

  Route onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _watchCubit,
            child: const HomePage(),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const UnknownRouteScreen(),
        );
    }
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
