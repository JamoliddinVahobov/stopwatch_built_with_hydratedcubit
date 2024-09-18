part of 'stopwatch_cubit.dart';

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

  Map<String, dynamic> toMap() {
    return {
      'elapsedTime': elapsedTime,
      'isRunning': isRunning,
      'stoppedTimes':
          stoppedTimes.map((e) => e).toList(), // Ensure it's a List<int>
    };
  }

  factory WatchState.fromMap(Map<String, dynamic> map) {
    return WatchState(
      elapsedTime: map['elapsedTime'] as int,
      isRunning: map['isRunning'] as bool,
      stoppedTimes:
          List<int>.from(map['stoppedTimes']), // Safely cast to List<int>
    );
  }

  String toJson() => json.encode(toMap());

  factory WatchState.fromJson(String source) =>
      WatchState.fromMap(json.decode(source) as Map<String, dynamic>);
}
