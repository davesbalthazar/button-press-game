// game_state.dart
part of 'game_bloc.dart';

abstract class GameState extends Equatable {
  const GameState();

  @override
  List<Object> get props => [];
}

class GameInitial extends GameState {}

class GameInProgress extends GameState {
  final List<int> activeButtonIndexes;

  const GameInProgress({required this.activeButtonIndexes});

  @override
  List<Object> get props => [activeButtonIndexes];
}

class GameOver extends GameState {}
