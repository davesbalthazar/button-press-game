import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'dart:async';
import 'dart:math';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final int totalButtons = 10;
  final Random random = Random();
  Timer? _timer;
  int _level = 1;

  GameBloc() : super(GameInitial()) {
    on<StartGame>(_onStartGame);
    on<ButtonPressed>(_onButtonPressed);
    _startNewRound();
  }

  void _onStartGame(StartGame event, Emitter<GameState> emit) {
    _level = 1;
    _startNewRound();
  }

  void _onButtonPressed(ButtonPressed event, Emitter<GameState> emit) {
    if (state is GameInProgress &&
        (state as GameInProgress).activeButtonIndexes.contains(event.index)) {
      _level++;
      _startNewRound();
    } else {
      emit(GameOver());
      _startNewRound();
    }
  }

  void _startNewRound() {
    _timer?.cancel();
    int activeButtonsCount = min(_level, totalButtons);
    List<int> activeButtonIndexes = [];

    while (activeButtonIndexes.length < activeButtonsCount) {
      int index = random.nextInt(totalButtons);
      if (!activeButtonIndexes.contains(index)) {
        activeButtonIndexes.add(index);
      }
    }

    emit(GameInProgress(activeButtonIndexes: activeButtonIndexes));
    _timer = Timer(Duration(seconds: 5), () {
      add(StartGame());
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
