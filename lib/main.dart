import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:solitaire_app/ui/widgets/closed_deck.dart';
import 'package:solitaire_app/ui/widgets/columns_widget.dart';
import 'package:solitaire_app/ui/widgets/confetti.dart';
import 'package:solitaire_app/ui/widgets/dialogs/show_alert_dialog.dart';
import 'package:solitaire_app/ui/widgets/foundation/foundation_widget.dart';
import 'package:solitaire_app/ui/widgets/opened_deck.dart';
import 'package:solitaire_app/ui/widgets/dialogs/confirm_new_game_dialog.dart';
import 'package:solitaire_app/domain/state/providers/game.dart';
import 'package:solitaire_app/constants.dart';
import 'package:solitaire_app/ui/widgets/floating_action_button_container.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Game(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future future;

  @override
  void initState() {
    future = Provider.of<Game>(context, listen: false).fetchAndLoadGame();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final gradientStart =
        Colors.deepPurple[700]; //Change start gradient color here
    final gradientEnd = Colors.purple[500]; //Change end gradient color here

    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    return Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Stack(
        children: <Widget>[
          FloatingActionButtorContainer(
              icon: Icons.add_outlined,
              position: 'left',
              onPressedCallback: () {
                showAlertDialog(context, const ConfirmNewGameDialog());
              }),
          FloatingActionButtorContainer(
            icon: Icons.arrow_back,
            position: 'right',
            onPressedCallback: () {
              Provider.of<Game>(context, listen: false).pushCancelMoveEvent();
            },
          )
        ],
      ),
      backgroundColor: Colors.purple,
      body: FutureBuilder(
        future: future,
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [gradientStart, gradientEnd],
                          begin: const FractionalOffset(0.5, 0.0),
                          end: const FractionalOffset(0.0, 0.5),
                          stops: const [0.0, 1.0],
                          tileMode: TileMode.clamp)),
                  child: Padding(
                      padding: isLandscape
                          ? EdgeInsets.symmetric(
                              vertical: 28,
                              horizontal: horizontalTotalPadding.toDouble())
                          : EdgeInsets.symmetric(
                              vertical: 40,
                              horizontal: horizontalTotalPadding.toDouble()),
                      child: Container(
                        height: mediaQuery.size.height + 400,
                        child: Stack(
                          overflow: Overflow.visible,
                          children: [
                            const ClosedDeck(),
                            const OpenedDeck(),
                            const ColumnsWidget(),
                            const FoundationWidget(),
                            Confetti()
                          ],
                        ),
                      )),
                ),
              ),
      ),
    );
  }
}
