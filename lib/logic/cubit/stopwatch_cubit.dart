import 'dart:async';
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'stopwatch_state.dart';

class WatchCubit extends HydratedCubit<WatchState> {
  WatchCubit()
      : super(const WatchState(
            elapsedTime: 0, isRunning: false, stoppedTimes: []));

  Timer? _timer;

  Future<void> start() async {
    if (state.isRunning) return;
    _timer = Timer.periodic(
      const Duration(milliseconds: 1),
      (timer) {
        emit(
          WatchState(
            elapsedTime: state.elapsedTime + 1,
            isRunning: true,
            stoppedTimes: state.stoppedTimes,
          ),
        );
      },
    );
  }

  Future<void> stop() async {
    _timer?.cancel();
    final stoppedTime = state.elapsedTime;
    final newStoppedTimes = List<int>.from(state.stoppedTimes)
      ..add(stoppedTime);

    emit(WatchState(
      elapsedTime: state.elapsedTime,
      isRunning: false,
      stoppedTimes: newStoppedTimes,
    ));
  }

  Future<void> reset() async {
    _timer?.cancel();
    emit(WatchState(
      elapsedTime: 0,
      isRunning: false,
      stoppedTimes: state.stoppedTimes,
    ));
  }

  Future<void> clearList() async {
    emit(
      WatchState(
        elapsedTime: state.elapsedTime,
        isRunning: state.isRunning,
        stoppedTimes: const [],
      ),
    );
  }

  Future<void> deleteStoppedTime(int index) async {
    final updatedTimes = List<int>.from(state.stoppedTimes)..removeAt(index);
    emit(WatchState(
      elapsedTime: state.elapsedTime,
      isRunning: state.isRunning,
      stoppedTimes: updatedTimes,
    ));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  @override
  WatchState? fromJson(Map<String, dynamic> json) {
    return WatchState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(WatchState state) {
    return state.toMap();
  }
}
