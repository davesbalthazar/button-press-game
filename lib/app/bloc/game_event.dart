part of 'game_bloc.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

class StartGame extends GameEvent {}

class ButtonPressed extends GameEvent {
  final int index;

  const ButtonPressed(this.index);

  @override
  List<Object> get props => [index];
}
