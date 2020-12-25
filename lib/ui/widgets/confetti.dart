import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

import 'dart:math';

import 'package:solitaire_app/ui/widgets/dialogs/confirm_new_game_dialog.dart';
import 'package:solitaire_app/ui/widgets/dialogs/show_alert_dialog.dart';

class Confetti extends StatefulWidget {
  final double height;
  Confetti({Key key, @required this.height}) : super(key: key);

  @override
  _ConfettiState createState() => _ConfettiState();
}

class _ConfettiState extends State<Confetti> {
  ConfettiController _controllerCenter;
  ConfettiController _controllerCenterRight;
  ConfettiController _controllerCenterLeft;
  ConfettiController _controllerTopCenter;
  ConfettiController _controllerBottomCenter;

  @override
  void initState() {
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));

    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerCenterRight =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerCenterLeft =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    _controllerBottomCenter =
        ConfettiController(duration: const Duration(seconds: 10));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _controllerCenter.play();
    _controllerCenterRight.play();
    _controllerCenterLeft.play();
    _controllerTopCenter.play();
    _controllerBottomCenter.play();
    return InkWell(
      onTap: () => showAlertDialog(context, ConfirmNewGameDialog()),
      child: Container(
          height: widget.height,
          child: Stack(
            children: <Widget>[
              //CENTER -- Blast
              Align(
                alignment: Alignment.center,
                child: ConfettiWidget(
                  confettiController: _controllerCenter,
                  blastDirectionality: BlastDirectionality
                      .explosive, // don't specify a direction, blast randomly
                  shouldLoop:
                      true, // start again as soon as the animation is finished
                  colors: const [
                    Colors.green,
                    Colors.blue,
                    Colors.pink,
                    Colors.orange,
                    Colors.purple
                  ], // manually specify the colors to be used
                ),
              ),

              //CENTER RIGHT -- Emit left
              Align(
                alignment: Alignment.centerRight,
                child: ConfettiWidget(
                  confettiController: _controllerCenterRight,
                  blastDirection: pi, // radial value - LEFT
                  particleDrag: 0.05, // apply drag to the confetti
                  emissionFrequency: 0.05, // how often it should emit
                  numberOfParticles: 20, // number of particles to emit
                  gravity: 0.05, // gravity - or fall speed
                  shouldLoop: false,
                  colors: const [
                    Colors.green,
                    Colors.blue,
                    Colors.pink
                  ], // manually specify the colors to be used
                ),
              ),

              //CENTER LEFT - Emit right
              Align(
                alignment: Alignment.centerLeft,
                child: ConfettiWidget(
                  confettiController: _controllerCenterLeft,
                  blastDirection: 0, // radial value - RIGHT
                  emissionFrequency: 0.6,
                  minimumSize: const Size(10,
                      10), // set the minimum potential size for the confetti (width, height)
                  maximumSize: const Size(50,
                      50), // set the maximum potential size for the confetti (width, height)
                  numberOfParticles: 1,
                  gravity: 0.1,
                ),
              ),

              //TOP CENTER - shoot down
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _controllerTopCenter,
                  blastDirection: pi / 2,
                  maxBlastForce: 5, // set a lower max blast force
                  minBlastForce: 2, // set a lower min blast force
                  emissionFrequency: 0.05,
                  numberOfParticles: 50, // a lot of particles at once
                  gravity: 1,
                ),
              ),

              //BOTTOM CENTER
              Align(
                alignment: Alignment.bottomCenter,
                child: ConfettiWidget(
                  confettiController: _controllerBottomCenter,
                  blastDirection: -pi / 2,
                  emissionFrequency: 0.01,
                  numberOfParticles: 20,
                  maxBlastForce: 100,
                  minBlastForce: 80,
                  gravity: 0.3,
                ),
              ),
            ],
          )),
    );
  }
}
