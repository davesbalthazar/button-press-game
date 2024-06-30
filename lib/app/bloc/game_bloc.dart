import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:async';
import 'dart:math';

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
          _startNewRound();
        } else {
          emit(GameInProgress(activeButtonIndexes: updatedActiveIndexes));
        }
      } else {
        emit(GameOver(message: 'Você perdeu!'));
        _startNewRound();
      }
    }
  }

  void _startNewRound() {
    print('START NEW ROUND');
    _timer?.cancel();
    _activeButtonIndexes.clear();

    // Escolhe aleatoriamente 'buttonsPerRound' botões para acesar nesta rodada
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
