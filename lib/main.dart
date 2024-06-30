import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'game_bloc.dart';

void main() {
  runApp(ButtonPressGameApp());
}

class ButtonPressGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Button Press Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => GameBloc(),
        child: ButtonPressGamePage(),
      ),
    );
  }
}

class ButtonPressGamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Button Press Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildButtonRow(context, 3),
            buildButtonRow(context, 4),
            buildButtonRow(context, 3),
          ],
        ),
      ),
    );
  }

  Widget buildButtonRow(BuildContext context, int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircularButton(index: index),
        );
      }),
    );
  }
}

class CircularButton extends StatelessWidget {
  final int index;

  CircularButton({required this.index});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        bool isActive = state is GameInProgress &&
            state.activeButtonIndexes.contains(index);

        return GestureDetector(
          onTap: isActive
              ? () {
                  context.read<GameBloc>().add(ButtonPressed(index));
                }
              : null,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isActive ? Colors.green : Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}
