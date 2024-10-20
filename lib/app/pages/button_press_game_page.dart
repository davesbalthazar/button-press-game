import 'package:button_press_game/app/bloc/game_bloc.dart';
import 'package:button_press_game/app/widgets/game_image_button.dart';
import 'package:button_press_game/components/game_score.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soundpool/soundpool.dart';

class ButtonPressGamePage extends StatefulWidget {
  const ButtonPressGamePage({super.key});

  @override
  State<ButtonPressGamePage> createState() => _ButtonPressGamePageState();
}

class _ButtonPressGamePageState extends State<ButtonPressGamePage> {
  Soundpool pool = Soundpool.fromOptions(
    options:
        const SoundpoolOptions(streamType: StreamType.alarm, maxStreams: 2),
  );

  int level = 1;

  int? soundPick;
  int? soundWin;
  int? soundLose;

  List<List<String>> map = [
    // ['X', 'X'],
    // ['X', 'X', 'X'],
    // ['X', 'X'],

    // ['X'],
    // ['X', 'X'],
    ['X', 'X', 'X'],
    ['X', 'X', 'X', 'X'],
    ['X', 'X', 'X'],
    // //['X', 'X'],

    // ['X', 'X', 'X', 'X'],
    // ['X', 'X', 'X', 'X', 'X'],
    // ['X', 'X', 'X', 'X'],

    // ['X', 'X', 'X', 'X', 'X', 'X'],
    // ['X', 'X', 'X', 'X', 'X', 'X'],
    // ['X', 'X', 'X', 'X', 'X', 'X'],
    // ['X', 'X', 'X', 'X', 'X', 'X'],
    // ['X', 'X', 'X', 'X', 'X', 'X'],
    // ['X', 'X', 'X', 'X', 'X', 'X'],
    // ['X', 'X', 'X', 'X', 'X', 'X'],
  ];

  // var levelName = 'snow';
  // var levelActiveColor = Colors.redAccent;
  // var levelInactiveColor = Colors.white;

  // var levelName = 'grass';
  // var levelActiveColor = Colors.greenAccent;
  // var levelInactiveColor = Colors.white;

  var levelName = 'snow';
  var levelActiveColor = Colors.red;
  var levelInactiveColor = Colors.white;

  var j = 0;

  @override
  void initState() {
    super.initState();

    loadSounds();
  }

  Future<void> loadSounds() async {
    soundPick = await rootBundle
        .load('assets/sounds/pop1.wav')
        .then((ByteData soundData) {
      return pool.load(soundData);
    });

    soundWin = await rootBundle
        .load('assets/sounds/win.wav')
        .then((ByteData soundData) {
      return pool.load(soundData);
    });

    soundLose = await rootBundle
        .load('assets/sounds/lose.wav')
        .then((ByteData soundData) {
      return pool.load(soundData);
    });
  }

  void _playSound(int soundId) async {
    pool.play(soundId);
  }

  Widget _incrementJ(int increment) {
    j += increment;
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Button Press Game'),
      // ),
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
            _playSound(soundWin!);
          } else if (state is GameOver) {
            _playSound(soundLose!);
          }

          return Stack(
            children: [
              Image.asset(
                'assets/images/levels/$levelName/background.png',

                // 'assets/images/background0.png',
                // 'assets/images/background' +
                //     Random().nextInt(2).toString() +
                //     '.png',
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 56),
                    //                     Row(
                    //                       mainAxisAlignment: MainAxisAlignment.center,
                    //                       children: [
                    //                         ElevatedButton(
                    //                           onPressed: () {
                    //                             // context.read<GameBloc>().add(StartGame(level));
                    //                           },
                    //                           child: const Text('Start Game'),
                    //                         ),
                    //                         const SizedBox(width: 20),
                    //                         ElevatedButton(
                    //                           onPressed: () {
                    // //                            context.read<GameBloc>().add(ResetGame());
                    //                           },
                    //                           child: const Text('Reset Game'),
                    //                         ),
                    //                       ],
                    //                     ),

                    GameScore(),

                    // if (message != null && message.isNotEmpty)
                    //   DefaultTextStyle(
                    //     style: const TextStyle(
                    //       fontSize: 24,
                    //       fontWeight: FontWeight.bold,
                    //       color: Colors.blueAccent,
                    //     ),
                    //     child: AnimatedTextKit(
                    //       animatedTexts: [
                    //         TypewriterAnimatedText(message),
                    //       ],
                    //       repeatForever: true,
                    //       isRepeatingAnimation: false,
                    //     ),
                    //   ),
                    Spacer(),

                    const SizedBox(height: 20),
                    ...renderMap(context, map, state),
                    Spacer(),
                  ],
                ),
              ),
            ],
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
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    int i = 0;

    double buttonSizeX = isPortrait
        ? MediaQuery.of(context).size.width * 0.7 / maxItemsInLine
        : MediaQuery.of(context).size.height * 0.7 / maxItemsInLine;
    double buttonSizeY = buttonSizeX;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: row.map((item) {
        i++;
        return Padding(
            padding: const EdgeInsets.all(4.0),
            child: item[0] == 'X'
                ? GameImageButton(
                    index: from + i,
                    isBlinking: state is BlinkingLights,
                    width: buttonSizeX,
                    height: buttonSizeY,
                    isPulsing: false,
                    activeImage: 'assets/images/levels/$levelName/active.png',
                    inactiveImage:
                        'assets/images/levels/$levelName/inactive.png',
                    activeColorShadow: levelActiveColor,
                    inactiveColorShadow: levelInactiveColor,

                    // isPulsing: true,
                    // isPulsing: Random().nextInt(10) == 0,
                    // isPulsing: Random().nextBool(),
                    //state is Pulsing,

                    // shape: BoxShape.rectangle,

                    playSoundPick: () {
                      _playSound(soundPick!);
                    },
                    playSoundError: () {
                      _playSound(soundLose!);
                    },
                  )
                : const SizedBox());
      }).toList(),
    );
  }
}
