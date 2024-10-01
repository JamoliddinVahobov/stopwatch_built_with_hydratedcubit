import 'dart:async';
import 'package:app_with_bloc/logic/cubit/stopwatch_state.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class WatchCubit extends HydratedCubit<WatchState> {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;

  WatchCubit()
      : super(const WatchState(
          elapsedTime: 0,
          isRunning: false,
          stoppedTimes: [],
        ));

  @override
  WatchState? fromJson(Map<String, dynamic> json) {
    try {
      return WatchState.fromMap(json);
    } catch (e) {
      return const WatchState(
        elapsedTime: 0,
        isRunning: false,
        stoppedTimes: [],
      );
    }
  }

  @override
  Map<String, dynamic>? toJson(WatchState state) {
    try {
      return state.toMap();
    } catch (e) {
      return null;
    }
  }

  Future<void> start() async {
    if (state.isRunning) return;

    _stopwatch.start();
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      emit(state.copyWith(elapsedTime: _stopwatch.elapsedMilliseconds));
    });
    emit(state.copyWith(isRunning: true));
  }

  Future<void> saveTime() async {
    if (state.isRunning) {
      final savedTime = state.elapsedTime;
      final updatedTimes = List<int>.from(state.stoppedTimes)..add(savedTime);

      emit(state.copyWith(
        stoppedTimes: updatedTimes,
      ));
    }
  }

  Future<void> stop() async {
    _timer?.cancel();
    _stopwatch.stop();
    final stoppedTime = state.elapsedTime;
    final newStoppedTimes = List<int>.from(state.stoppedTimes)
      ..add(stoppedTime);

    emit(state.copyWith(
      isRunning: false,
      stoppedTimes: newStoppedTimes,
    ));
  }

  Future<void> reset() async {
    _timer?.cancel();
    _stopwatch.reset();
    emit(state.copyWith(
      elapsedTime: 0,
      isRunning: false,
    ));
  }

  Future<void> clearList() async {
    _stopwatch.reset();
    _timer?.cancel();
    emit(const WatchState(
      elapsedTime: 0,
      isRunning: false,
      stoppedTimes: [],
    ));
  }

  Future<void> deleteStoppedTime(int index) async {
    final updatedTimes = List<int>.from(state.stoppedTimes)..removeAt(index);
    emit(state.copyWith(
      stoppedTimes: updatedTimes,
    ));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
