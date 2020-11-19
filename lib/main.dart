import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:solitaire_app/widgets/suit_foundation.dart';

import 'widgets/card_column.dart';
import 'widgets/playing_card.dart';
import 'widgets/deck_widget.dart';
import 'widgets/confetti.dart';

import 'providers/game.dart';
import 'models/card_model.dart';
import 'constants.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Game(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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
    final gameProvider = Provider.of<Game>(context, listen: false);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    return Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: Container(
        width: 30,
        child: FloatingActionButton(
          child: Icon(Icons.add_outlined),
          onPressed: () {
            _showMyDialog(context);
          },
        ),
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
                        height: mediaQuery.size.height,
                        child: Stack(
                          overflow: Overflow.visible,
                          children: [
                            Selector<Game, int>(
                                selector: (ctx, game) =>
                                    gameProvider.deckLength,
                                builder: (context, deckLength, child) =>
                                    deckLength > 0
                                        ? Stack(
                                            overflow: Overflow.visible,
                                            children: [
                                              if (deckLength > 1)
                                                ...List.generate(deckLength - 1,
                                                        (i) => i)
                                                    .map((e) => Positioned(
                                                        left:
                                                            (e * 2).toDouble(),
                                                        child: CardWidget(
                                                          decorate: false,
                                                          isLandscape:
                                                              isLandscape,
                                                          card: CardModel(
                                                              played: false),
                                                          width: mediaQuery
                                                              .size.width,
                                                        ))),
                                              Positioned(
                                                left: ((deckLength - 1) * 2)
                                                    .toDouble(),
                                                child: InkWell(
                                                  focusColor: Colors.amber,
                                                  onTap: gameProvider
                                                      .pushChangeEvent,
                                                  child: CardWidget(
                                                    isLandscape: isLandscape,
                                                    card: CardModel(
                                                        played: false),
                                                    width:
                                                        mediaQuery.size.width,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Container()),
                            Container(
                              child: Selector<Game, List>(
                                selector: (ctx, game) => game.deck,
                                builder: (ctx, game, child) {
                                  print("BUILD DECK");
                                  return game.isEmpty
                                      ? Container()
                                      : DeckWidget(
                                          isLandscape: isLandscape,
                                          deck: game,
                                          mediaQuery: mediaQuery);
                                },
                              ),
                            ),
                            buildCardColumn(0, isLandscape, context),
                            buildCardColumn(1, isLandscape, context),
                            buildCardColumn(2, isLandscape, context),
                            buildCardColumn(3, isLandscape, context),
                            buildCardColumn(4, isLandscape, context),
                            buildCardColumn(5, isLandscape, context),
                            buildCardColumn(6, isLandscape, context),
                            buildFoundation(
                                mediaQuery,
                                'spade',
                                3,
                                gameProvider.deck.length,
                                isLandscape,
                                gameProvider.initial),
                            buildFoundation(
                                mediaQuery,
                                'club',
                                4,
                                gameProvider.deck.length,
                                isLandscape,
                                gameProvider.initial),
                            buildFoundation(
                                mediaQuery,
                                'diamond',
                                5,
                                gameProvider.deck.length,
                                isLandscape,
                                gameProvider.initial),
                            buildFoundation(
                                mediaQuery,
                                'heart',
                                6,
                                gameProvider.deck.length,
                                isLandscape,
                                gameProvider.initial),
                            Selector<Game, bool>(
                              selector: (ctx, game) => game.win,
                              builder: (context, win, child) =>
                                  win ? Confetti() : Container(),
                            ),
                          ],
                        ),
                      )),
                ),
              ),
      ),
    );
  }

  Selector<Game, Map> buildFoundation(MediaQueryData mediaQuery, String suit,
          int position, int deckLength, bool isLandscape, bool gameInitial) =>
      Selector<Game, Map>(selector: (ctx, game) {
        return (game.foundation[suit] != null) ? game.foundation[suit] : null;
      }, builder: (ctx, foundation, child) {
        print('rebuilding $suit......');

        return foundation == null
            ? Container()
            : SuitFoundation(
                height: mediaQuery.size.height,
                isLandscape: isLandscape,
                foundation: foundation,
                width: mediaQuery.size.width,
                suit: CardModel.fetchSuit(suit),
                position: position,
                gameInitial: gameInitial);
      }, shouldRebuild: (previous, next) {
        if (previous == null) {
          return true;
        }
        return previous['rank'] != next['rank'];
      });

  Selector<Game, List> buildCardColumn(
      int index, bool isLandscape, BuildContext context) {
    return Selector<Game, List>(
      selector: (ctx, game) =>
          game.columns.isNotEmpty ? game.columns[index] : null,
      builder: (ctx, columnsData, child) {
        return columnsData == null
            ? Container()
            : CardColumn(
                gameInitial: Provider.of<Game>(context, listen: false).initial,
                isLandscape: isLandscape,
                cards: columnsData,
                columnIndex: index,
                width: MediaQuery.of(context).size.width);
      },
    );
  }
}

Future<void> _showMyDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: const Center(child: const Text('Start new game')),
        content: Text(
          'Are you sure you want to start new game?',
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Ok'),
            onPressed: () {
              Provider.of<Game>(context, listen: false).startNewGame();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
