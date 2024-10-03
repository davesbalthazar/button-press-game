import 'package:button_press_game/app/bloc/game_bloc.dart';
import 'package:button_press_game/app/widgets/game_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audioplayers.dart';

class ButtonPressGamePage extends StatelessWidget {
  final AudioPlayer _audioPlayer = AudioPlayer();

  int level = 1;

  List<List<String>> map = [
    // ['X'],
    // ['X', 'X'],
    ['X', 'X', 'X'],
    ['X', 'X', 'X', 'X'],
    ['X', 'X', 'X'],
    //['X', 'X'],
  ];

  var j = 0;

  ButtonPressGamePage({super.key});

  void _playSound(String sound) {
    _audioPlayer.play(AssetSource(sound));
  }

  Widget _incrementJ(int increment) {
    j += increment;
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Button Press Game'),
      ),
      body: BlocBuilder<GameBloc, GameState>(
        builder: (context, state) {
          String? message = '';
          int points = 0;

          if (state is GameInitial) {
            message = state.message;
          } else if (state is GameInProgress) {
            message = state.message;
            // points = state.points;
          } else if (state is GameWon) {
            message = state.message;
          } else if (state is GameOver) {
            message = state.message;
          }
          print(state);

          if (state is GameWon) {
            // _playSound('assets/sounds/win.wav');
            _playSound('sounds/win.wav');
          } else if (state is GameOver) {
            _playSound('sounds/lose.wav');
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (message != null && message.isNotEmpty)
                  DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(message),
                      ],
                      repeatForever: true,
                      isRepeatingAnimation: false,
                    ),
                  ),
                const SizedBox(height: 20),
                ...renderMap(context, map, state),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> renderMap(
      BuildContext context, List<List<String>> map, GameState state) {
    List<Widget> rows = [];

    // Calcula o máximo de itens nas linhas
    int maxItensInLine = 0;
    for (var i = 0; i < map.length; i++) {
      if (map[i].length > maxItensInLine) {
        maxItensInLine = map[i].length;
      }
    }
    print('maxItensInLine: $maxItensInLine');

    int counter = 0;
    // Colunas
    for (var i = 0; i < map.length; i++) {
      print(counter);

      rows.add(Column(
        children: [
          buildButtonRow2(context, counter, map[i], maxItensInLine, state),
          const SizedBox(height: 20),
        ],
      ));
      counter = counter + map[i].length;
    }

    return rows;
  }

  Widget buildButtonRow2(BuildContext context, int from, List<String> row,
      int maxItemsInLine, GameState state) {
    int i = 0;

    double buttonSizeX =
        MediaQuery.of(context).size.width * 0.8 / maxItemsInLine;
    // double buttonSizeY = MediaQuery.of(context).size.height / maxItemsInLine;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: row.map((item) {
        i++;
        return Padding(
            padding: const EdgeInsets.all(4.0),
            child: item[0] == 'X'
                ? GameButton(
                    index: from + i,
                    isBlinking: state is BlinkingLights,
                    width: buttonSizeX,
                    // height: buttonSizeY,
                  )
                : const SizedBox());
      }).toList(),
    );
  }

  Widget buildButtonRow(BuildContext context, int from, int count,
      int MaxItensInLine, GameState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GameButton(
              index: index + from, isBlinking: state is BlinkingLights),
        );
      }),
    );
  }
}
