import 'dart:math';

import 'package:button_press_game/app/bloc/game_bloc.dart';
import 'package:button_press_game/app/enums/map_type.dart';
import 'package:button_press_game/app/models/level.dart';
import 'package:button_press_game/app/models/map.dart';
import 'package:button_press_game/app/widgets/circular_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audioplayers/audioplayers.dart';

class ButtonPressGamePage extends StatelessWidget {
  final AudioPlayer _audioPlayer = AudioPlayer();

  int level = 1;

  List<List<String>> map = [
    ['X'],
    ['X', 'X'],
    ['X', 'X', 'X'],
    ['X', 'X', 'X', 'X'],
    ['X', 'X'],
    ['X', 'X'],
  ];

  var j = 0;

  void _playSound(String sound) {
    _audioPlayer.play(AssetSource(sound));
  }

  Widget _incrementJ(int increment) {
    j += increment;
    return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Button Press Game'),
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
                    style: TextStyle(
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
                SizedBox(height: 20),

                ...renderMap(context, map, state),

//                 for (var i = 0; i < map.length; i++) ...[
//                   buildButtonRow2(context, i + j, map[i], state),

// //                  Text((i + j).toString()),
//                   _incrementJ(map[i].length),
//                 ],
                //buildButtonRow2(context, i + map[i].length, map[i], state),

                // for (var row in map) ...[
                //   buildButtonRow2(context, row.length, row, state)
                // ],

                // map.forEach((row) {
                //   return Text('x');
                //   //  return buildButtonRow2(context, 0, row, state);
                // }),

                // map.map((row) {
                //   return buildButtonRow2(context, 0, row, state);
                // }).toList(),
                // map.add(
                //   GameMap(x: 1, y: 1, mapType: MapType.circle);

// map.add([GameMap(x: 1, y: 1, mapType: MapType.circle)]);
                // .addAll([
                // [GameMap(1,1,MapType.circle), GameMap(1,2,MapType.square), GameMap(1,3,MapType.circle), GameMap(1,4,MapType.square)],
                // [GameMap(2,1,MapType.square), GameMap(2,2,MapType.circle), GameMap(2,3,MapType.square)]);

                // map = [
                //     ['X', '0', 'X', '0'], // Linha com 4 itens
                //     ['0', 'X', '0'], // Linha com 3 itens
                //     ['X', 'X', '0', 'X'], // Linha com 4 itens
                //     ['0', '0', 'X'], // Linha com 3 itens
                //   ];

//                print( Level.generateLevel(1).toList().toString() );

                // Text( state.props.points.toString(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),),;

                // for (int i = 0; i < 10; i += 3)
                //   buildButtonRow(context, i, 3, state),

                // buildButtonRow(context, 0, 3, state),
                // buildButtonRow(context, 3, 4, state),
                // buildButtonRow(context, 7, 3, state),
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

    int counter = 0;
    // Colunas
    for (var i = 0; i < map.length; i++) {
      print(counter);

      rows.add(Column(
        children: [
          buildButtonRow2(context, counter, map[i], state),
          SizedBox(height: 20),
        ],
      ));
      counter = counter + map[i].length;
      // return buildButtonRow2(context, i, map[i], state);
      // Linhas
      // for (var j = 0; j < map[i].length; j++) {
      //   print(map[i][j]);
      // }
    }

    return rows;
  }

  Widget buildButtonRow2(
      BuildContext context, int from, List<String> row, GameState state) {
    int i = 0;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: row.map((item) {
        i++;
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: item[0] == 'X'
                ? CircularButton(
                    index: from + i, isBlinking: state is BlinkingLights)
                : SizedBox());
      }).toList(),
    );
  }

  Widget buildButtonRow(
      BuildContext context, int from, int count, GameState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircularButton(
              index: index + from, isBlinking: state is BlinkingLights),
        );
      }),
    );
  }
}
