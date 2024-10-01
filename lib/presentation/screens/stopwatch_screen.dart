import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_with_bloc/logic/cubit/stopwatch_cubit.dart';
import '../../logic/cubit/stopwatch_state.dart';

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  Future<void> _handleClearAll() async {
    final cubit = context.read<WatchCubit>();
    if (cubit.state.stoppedTimes.isNotEmpty) {
      final shouldClear = await _showClearDialog();
      if (mounted && shouldClear == true) {
        cubit.clearList();
      }
    }
  }

  Future<bool?> _showClearDialog() {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
                maxHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Do you want to delete all times?',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        title: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('Stopwatch'),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'settings');
                },
                icon: const Icon(
                  Icons.tune,
                )),
          )
        ],
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        )),
      ),
      body: SafeArea(
        child: BlocBuilder<WatchCubit, WatchState>(
          builder: (context, state) {
            final elapsedTime = state.elapsedTime;
            final seconds = (elapsedTime / 1000).floor() % 60;
            final minutes = (elapsedTime / 60000).floor() % 60;
            final hours = (elapsedTime / 3600000).floor();
            final milliseconds = (elapsedTime % 1000) ~/ 10;

            String formattedElapsedTime;
            if (hours > 0) {
              formattedElapsedTime =
                  '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${milliseconds.toString().padLeft(2, '0')}';
            } else {
              formattedElapsedTime =
                  '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${milliseconds.toString().padLeft(2, '0')}';
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.stoppedTimes.length,
                    itemBuilder: (context, index) {
                      final reversedTimes =
                          state.stoppedTimes.reversed.toList();
                      final timeInMillis = reversedTimes[index];
                      final displayIndex = reversedTimes.length - index;

                      final seconds = (timeInMillis / 1000).floor() % 60;
                      final minutes = (timeInMillis / 60000).floor() % 60;
                      final hours = (timeInMillis / 3600000).floor();
                      final milliseconds = (timeInMillis % 1000) ~/ 10;

                      String formattedTime;
                      String timeUnit;

                      if (hours > 0) {
                        formattedTime =
                            '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
                        timeUnit = 'hours';
                      } else if (minutes > 0) {
                        formattedTime =
                            '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
                        timeUnit = 'minutes';
                      } else {
                        formattedTime =
                            '${seconds.toString().padLeft(2, '0')}.${milliseconds.toString().padLeft(2, '0')}';
                        timeUnit = 'seconds';
                      }
                      return Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: ListTile(
                          leading: Text(
                            '$displayIndex.',
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.blue[300]
                                  : Colors.blue[900],
                            ),
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
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.red[500]
                                  : Colors.red[900],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: height * 0.04),
                  decoration: BoxDecoration(
                      color: theme.colorScheme.onPrimary,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(35))),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: FittedBox(
                          child: Text(
                            formattedElapsedTime,
                            style: const TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const Divider(
                        thickness: 2,
                        color: Colors.grey,
                      ),
                      SizedBox(height: height * 0.06),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (state.isRunning) {
                                context.read<WatchCubit>().stop();
                              } else {
                                context.read<WatchCubit>().start();
                              }
                            },
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor:
                                  state.isRunning ? Colors.red : Colors.green,
                              child: Icon(
                                state.isRunning
                                    ? Icons.stop_rounded
                                    : Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.17),
                          GestureDetector(
                            onTap: () {
                              context.read<WatchCubit>().saveTime();
                            },
                            child: const CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.blue,
                              child: Icon(
                                Icons.flag,
                                color: Colors.white,
                                size: 35,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.04),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: _handleClearAll,
                            child: const CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.teal,
                              child: Icon(
                                Icons.clear_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.17),
                          GestureDetector(
                            onTap: () {
                              context.read<WatchCubit>().reset();
                            },
                            child: const CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.orange,
                              child: Icon(
                                Icons.restart_alt_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
