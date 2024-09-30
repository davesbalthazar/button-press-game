part of 'game_bloc.dart';

abstract class GameState extends Equatable {
  const GameState();

  String? get message => null;

  @override
  List<Object?> get props => [];
}

class GameInitial extends GameState {
  const GameInitial();

  @override
  String get message => 'Pressione para iniciar o jogo!';
}

class GameInProgress extends GameState {
  final List<int> activeButtonIndexes;

  const GameInProgress({
    required this.activeButtonIndexes,
    required this.points,
  });

  @override
  String get message => 'Clique nos botões acesos o mais rápido possível!';

  final int points;

  @override
  List<Object?> get props => [activeButtonIndexes, points];
}

class GameWon extends GameState {
  final String? message;

  const GameWon({this.message});

  @override
  List<Object?> get props => [message];
}

class GameOver extends GameState {
  final String? message;

  const GameOver({this.message});

  @override
  List<Object?> get props => [message];
}

class BlinkingLights extends GameState {
  final int blinkCount;

  const BlinkingLights({required this.blinkCount});

  @override
  List<Object?> get props => [blinkCount];
}
