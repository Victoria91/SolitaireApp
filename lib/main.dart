import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:solitaire_app/ui/widgets/closed_deck.dart';
import 'package:solitaire_app/ui/widgets/confetti.dart';
import 'package:solitaire_app/ui/widgets/dialogs/show_alert_dialog.dart';
import 'package:solitaire_app/ui/widgets/foundation/foundation_klondike.dart';
import 'package:solitaire_app/ui/widgets/foundation/foundation_spider.dart';
import 'package:solitaire_app/ui/widgets/opened_deck.dart';
import 'package:solitaire_app/ui/widgets/dialogs/confirm_new_game_dialog.dart';

import 'ui/widgets/card_column.dart';
import 'ui/widgets/closed_deck.dart';
import 'ui/widgets/opened_deck.dart';
import 'ui/widgets/confetti.dart';
import 'ui/widgets/floating_action_button_container.dart';

import 'package:solitaire_app/domain/state/providers/game.dart';
import 'constants.dart';

// data - слой работы с данными. На этом уровне, например, описываем работу с внешним API.

// domain - слой бизнес-логики.

// internal - слой приложения. На этом уровне происходит внедрение зависимостей.

// presentation - слой представления. На этом уровне описываем UI приложения.

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Game(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
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
    Color gradientStart =
        Colors.deepPurple[700]; //Change start gradient color here
    Color gradientEnd = Colors.purple[500]; //Change end gradient color here

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
                showAlertDialog(context, ConfirmNewGameDialog());
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
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [gradientStart, gradientEnd],
                          begin: const FractionalOffset(0.5, 0.0),
                          end: const FractionalOffset(0.0, 0.5),
                          stops: [0.0, 1.0],
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
                            ClosedDeck(),
                            Selector<Game, String>(
                                selector: (ctx, game) => game.type,
                                builder: (context, gameType, child) =>
                                    gameType == 'klondike'
                                        ? OpenedDeck()
                                        : Container()),
                            buildCardColumn(0, context),
                            buildCardColumn(1, context),
                            buildCardColumn(2, context),
                            buildCardColumn(3, context),
                            buildCardColumn(4, context),
                            buildCardColumn(5, context),
                            buildCardColumn(6, context),
                            buildCardColumn(7, context),
                            buildCardColumn(8, context),
                            buildCardColumn(9, context),
                            Selector<Game, List>(
                                builder: (context, gameType, child) {
                                  return gameType[0] == 'spider'
                                      ? FoundationSpider()
                                      : FoundationKlondike();
                                },
                                selector: (ctx, game) =>
                                    [game.type, game.initial]),
                            Selector<Game, bool>(
                              selector: (ctx, game) => game.win,
                              builder: (context, win, child) => win
                                  ? Confetti(height: mediaQuery.size.height)
                                  : Container(),
                            ),
                          ],
                        ),
                      )),
                ),
              ),
      ),
    );
  }

  Selector<Game, List> buildCardColumn(int index, BuildContext context) {
    final gameData = Provider.of<Game>(context, listen: false);
    return Selector<Game, List>(
      selector: (_ctx, game) =>
          game.columns.isNotEmpty && game.columns.length > index
              ? game.columns[index]
              : null,
      builder: (_ctx, columnsData, _child) {
        return columnsData == null
            ? Container()
            : CardColumn(
                gameInitial: gameData.initial,
                gameType: gameData.type,
                columnCount: gameData.columns.length,
                cards: columnsData,
                columnIndex: index,
                width: MediaQuery.of(context).size.width);
      },
    );
  }
}
