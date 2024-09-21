import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_with_bloc/logic/cubit/stopwatch_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _handleClearAll() async {
    final shouldClear = await _showClearDialog();
    if (mounted && shouldClear == true) {
      context.read<WatchCubit>().clearList();
    }
  }

  Future<bool?> _showClearDialog() {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
            'Do you want to delete all times',
            style: TextStyle(fontSize: 15),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User pressed Cancel
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User pressed Delete
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        toolbarHeight: 90, // Increased the toolbar height
        flexibleSpace: Center(
          child: BlocBuilder<WatchCubit, WatchState>(
            builder: (context, state) {
              final elapsedTime = state.elapsedTime;
              final seconds = (elapsedTime / 1000).floor();
              final milliseconds = elapsedTime % 1000;
              final formattedTime =
                  '$seconds.${milliseconds.toString().padLeft(3, '0')}';
              return Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Elapsed Time',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      formattedTime,
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocBuilder<WatchCubit, WatchState>(
                builder: (context, state) {
                  final reversedTimes = state.stoppedTimes.reversed.toList();
                  return ListView.builder(
                    itemCount: reversedTimes.length,
                    itemBuilder: (context, index) {
                      final timeInMillis = reversedTimes[index];
                      final displayIndex = reversedTimes.length - index;

                      final seconds = (timeInMillis / 1000).floor() % 60;
                      final minutes = (timeInMillis / 60000).floor() % 60;
                      final hours = (timeInMillis / 3600000).floor();

                      String formattedTime;
                      String timeUnit;

                      if (hours > 0) {
                        formattedTime =
                            '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
                        timeUnit = 'hours';
                      } else if (minutes > 0) {
                        formattedTime =
                            '$minutes:${seconds.toString().padLeft(2, '0')}';
                        timeUnit = 'minutes';
                      } else {
                        final milliseconds = timeInMillis % 1000;
                        formattedTime =
                            '$seconds.${milliseconds.toString().padLeft(3, '0')}';
                        timeUnit = 'seconds';
                      }
                      return Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: ListTile(
                          leading: Text(
                            '$displayIndex.',
                            style: TextStyle(
                                fontSize: 18, color: Colors.blue[900]),
                          ),
                          title: Text('$formattedTime $timeUnit'),
                          trailing: IconButton(
                            onPressed: () {
                              context
                                  .read<WatchCubit>()
                                  .deleteStoppedTime(index);
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red[900],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            // The button container remains fixed at the bottom
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              color: Colors.grey[200],
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.read<WatchCubit>().start();
                        },
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.green,
                          child: Icon(Icons.play_arrow, color: Colors.white),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.read<WatchCubit>().stop();
                        },
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.red,
                          child: Icon(Icons.stop, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20), // Space between rows
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.read<WatchCubit>().reset();
                        },
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.orange,
                          child: Icon(Icons.restart_alt, color: Colors.white),
                        ),
                      ),
                      GestureDetector(
                        onTap: _handleClearAll,
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.clear, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
