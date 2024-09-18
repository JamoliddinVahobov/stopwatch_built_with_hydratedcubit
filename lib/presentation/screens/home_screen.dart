// ignore_for_file: prefer_const_constructors
import 'package:app_with_bloc/logic/cubit/stopwatch_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          content: Text(
            'Do you want to delete all times',
            style: TextStyle(fontSize: 15),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User pressed Cancel
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User pressed Delete
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Stopwatch'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<WatchCubit, WatchState>(
                  builder: (context, state) {
                    final elapsedTime = state.elapsedTime;
                    final seconds = (elapsedTime / 1000).floor();
                    final milliseconds = elapsedTime % 1000;
                    final formattedTime =
                        '$seconds.${milliseconds.toString().padLeft(3, '0')}';
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Elapsed Time: ',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            formattedTime,
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton.filled(
                      onPressed: () {
                        context.read<WatchCubit>().start();
                      },
                      icon: Icon(Icons.play_arrow,
                          size: 30), // Changed start icon
                    ),
                    IconButton.filled(
                      onPressed: () {
                        context.read<WatchCubit>().stop();
                      },
                      icon: Icon(Icons.stop, size: 30),
                    ),
                    IconButton.filled(
                      onPressed: () {
                        context.read<WatchCubit>().reset();
                      },
                      icon: Icon(Icons.restart_alt, size: 30),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                BlocBuilder<WatchCubit, WatchState>(
                  builder: (context, state) {
                    final reversedTimes = state.stoppedTimes.reversed
                        .toList(); // Reverse the list manually
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: ListView.builder(
                          itemCount: reversedTimes.length,
                          itemBuilder: (context, index) {
                            final timeInMillis = reversedTimes[index];
                            final displayIndex = reversedTimes.length - index;

                            // Convert milliseconds to seconds, minutes, and hours
                            final seconds = (timeInMillis / 1000).floor() % 60;
                            final minutes = (timeInMillis / 60000).floor() % 60;
                            final hours = (timeInMillis / 3600000).floor();

                            String formattedTime;
                            String timeUnit;

                            if (hours > 0) {
                              // Format as hours:minutes:seconds
                              formattedTime =
                                  '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
                              timeUnit = 'hours';
                            } else if (minutes > 0) {
                              // Format as minutes:seconds
                              formattedTime =
                                  '$minutes:${seconds.toString().padLeft(2, '0')}';
                              timeUnit = 'minutes';
                            } else {
                              final milliseconds = timeInMillis % 1000;
                              formattedTime =
                                  '$seconds.${milliseconds.toString().padLeft(3, '0')}';
                              timeUnit = 'seconds';
                            }

                            return ListTile(
                              leading: Text(
                                '$displayIndex.',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.blue[900]),
                              ),
                              title: Text(
                                '$formattedTime $timeUnit',
                              ),
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
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _handleClearAll,
          tooltip: "Clear All",
          child: Icon(
            Icons.clear,
            size: 25,
          ),
        ),
      ),
    );
  }
}
