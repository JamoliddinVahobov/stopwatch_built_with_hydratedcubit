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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        toolbarHeight: 40,
        title: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('Stopwatch'),
        ),
        centerTitle: true,
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
            Container(
              padding: const EdgeInsets.only(bottom: 30),
              color: Colors.grey[200],
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BlocBuilder<WatchCubit, WatchState>(
                    builder: (context, state) {
                      final elapsedTime = state.elapsedTime;
                      final seconds = (elapsedTime / 1000).floor();
                      final milliseconds = elapsedTime % 1000;
                      final formattedTime =
                          '$seconds.${milliseconds.toString().padLeft(3, '0')}';
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FittedBox(
                            child: Text(
                              formattedTime,
                              style: const TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Divider(
                            thickness: 2,
                            color: Colors.grey,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.read<WatchCubit>().start();
                        },
                        child: const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.green,
                          child: Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                      const SizedBox(width: 60),
                      GestureDetector(
                        onTap: () {
                          context.read<WatchCubit>().stop();
                        },
                        child: const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.red,
                          child: Icon(
                            Icons.stop_rounded,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                      const SizedBox(width: 60),
                      GestureDetector(
                        onTap: _handleClearAll,
                        child: const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.clear_rounded,
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
        ),
      ),
    );
  }
}
