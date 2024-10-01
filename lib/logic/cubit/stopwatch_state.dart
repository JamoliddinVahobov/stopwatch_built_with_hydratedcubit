import 'dart:convert';
import 'package:equatable/equatable.dart';

class WatchState extends Equatable {
  final int elapsedTime;
  final bool isRunning;
  final List<int> stoppedTimes;

  const WatchState({
    required this.elapsedTime,
    required this.isRunning,
    required this.stoppedTimes,
  });

  @override
  List<Object?> get props => [elapsedTime, isRunning, stoppedTimes];

  WatchState copyWith({
    int? elapsedTime,
    bool? isRunning,
    List<int>? stoppedTimes,
  }) {
    return WatchState(
      elapsedTime: elapsedTime ?? this.elapsedTime,
      isRunning: isRunning ?? this.isRunning,
      stoppedTimes: stoppedTimes ?? this.stoppedTimes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'elapsedTime': elapsedTime,
      'isRunning': isRunning,
      'stoppedTimes': stoppedTimes,
    };
  }

  factory WatchState.fromMap(Map<String, dynamic> map) {
    return WatchState(
      elapsedTime: map['elapsedTime'] as int,
      isRunning: map['isRunning'] as bool,
      stoppedTimes: List<int>.from(map['stoppedTimes'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory WatchState.fromJson(String source) =>
      WatchState.fromMap(json.decode(source) as Map<String, dynamic>);
}
