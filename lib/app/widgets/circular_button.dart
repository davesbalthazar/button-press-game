import 'package:button_press_game/app/bloc/game_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
          onTap: () => context.read<GameBloc>().add(
                ButtonPressed(index),
              ),

          // isActive
          //     ? () {
          //         context.read<GameBloc>().add(ButtonPressed(index));
          //       }
          //     : null,
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: isActive ? Colors.green : Colors.grey,
              shape: BoxShape.circle,
            ),
            child: Text(index.toString(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center),
          ),
        );
      },
    );
  }
}
