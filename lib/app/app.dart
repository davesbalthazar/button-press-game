import 'package:button_press_game/app/bloc/game_bloc.dart';
import 'package:button_press_game/app/pages/button_press_game_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Button Press Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark,
      ),
      home: BlocProvider(
        create: (context) => GameBloc(),
        child: const ButtonPressGamePage(),
      ),
    );
  }
}
