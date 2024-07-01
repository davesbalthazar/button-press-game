import 'dart:async';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final int totalButtons = 10; // Total de botões disponíveis
  final int buttonsPerRound =
      3; // Quantidade de botões a serem acesos por rodada
  final Random random = Random();
  Timer? _timer;
  List<int> _activeButtonIndexes = [];

  GameBloc() : super(GameInitial()) {
    on<StartGame>(_onStartGame);
    on<ButtonPressed>(_onButtonPressed);
    on<TimerTicked>(_onTimerTicked);
    on<StartBlinking>(_onStartBlinking);
    on<BlinkTick>(_onBlinkTick);
    _startNewRound();
  }

  void _onStartGame(StartGame event, Emitter<GameState> emit) {
    _startNewRound();
  }

  void _onButtonPressed(ButtonPressed event, Emitter<GameState> emit) {
    if (state is GameInProgress) {
      List<int> updatedActiveIndexes =
          List.from((state as GameInProgress).activeButtonIndexes);

      if (updatedActiveIndexes.contains(event.index)) {
        updatedActiveIndexes.remove(event.index);

        if (updatedActiveIndexes.isEmpty) {
          _timer?.cancel();
          emit(GameWon(message: 'Parabéns, você venceu!'));
          add(StartBlinking());
        } else {
          emit(GameInProgress(activeButtonIndexes: updatedActiveIndexes));
        }
      } else {
        emit(GameOver(message: 'Você perdeu!'));
        _startNewRound();
      }
    }
  }

  void _onTimerTicked(TimerTicked event, Emitter<GameState> emit) {
    emit(GameOver(message: 'Tempo esgotado!'));
    _startNewRound();
  }

  void _onStartBlinking(StartBlinking event, Emitter<GameState> emit) {
    emit(BlinkingLights(blinkCount: 0));
    _timer = Timer.periodic(Duration(milliseconds: 12), (timer) {
      add(BlinkTick());
    });
  }

  void _onBlinkTick(BlinkTick event, Emitter<GameState> emit) {
    if (state is BlinkingLights) {
      int blinkCount = (state as BlinkingLights).blinkCount + 1;
      if (blinkCount >= 100) {
        _timer?.cancel();
        _startNewRound();
      } else {
        emit(BlinkingLights(blinkCount: blinkCount));
      }
    }
  }

  void _startNewRound() {
    _timer?.cancel();
    _activeButtonIndexes.clear();

    while (_activeButtonIndexes.length < buttonsPerRound) {
      int index = random.nextInt(totalButtons);
      if (!_activeButtonIndexes.contains(index)) {
        _activeButtonIndexes.add(index);
      }
    }

    emit(GameInProgress(
        activeButtonIndexes: List<int>.from(_activeButtonIndexes)));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}

class TimerTicked extends GameEvent {}

class StartBlinking extends GameEvent {}

class BlinkTick extends GameEvent {}
