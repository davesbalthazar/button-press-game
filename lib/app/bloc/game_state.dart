part of 'game_bloc.dart';

abstract class GameState extends Equatable {
  const GameState();

  String? get message => null; // Implementação padrão para todos os estados

  @override
  List<Object?> get props => [];
}

class GameInitial extends GameState {
  const GameInitial();

  @override
  String get message =>
      'Pressione para iniciar o jogo!'; // Mensagem específica para GameInitial
}

class GameInProgress extends GameState {
  final List<int> activeButtonIndexes;

  const GameInProgress({required this.activeButtonIndexes});

  @override
  String get message =>
      'Clique nos botões acesos o mais rápido possível!'; // Mensagem específica para GameInProgress

  @override
  List<Object?> get props => [activeButtonIndexes];
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
