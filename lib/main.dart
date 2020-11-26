import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:solitaire_app/widgets/suit_foundation.dart';

import 'widgets/card_column.dart';
import 'widgets/closed_deck.dart';
import 'widgets/opened_deck.dart';
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
                            ClosedDeck(),
                            OpenedDeck(),
                            buildCardColumn(0, context),
                            buildCardColumn(1, context),
                            buildCardColumn(2, context),
                            buildCardColumn(3, context),
                            buildCardColumn(4, context),
                            buildCardColumn(5, context),
                            buildCardColumn(6, context),
                            buildFoundation('spade', 3, context),
                            buildFoundation('club', 4, context),
                            buildFoundation('diamond', 5, context),
                            buildFoundation('heart', 6, context),
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

  Selector<Game, Map> buildFoundation(
      String suit, int position, BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Selector<Game, Map>(
        selector: (_ctx, game) => game.foundation[suit],
        builder: (_ctx, foundation, _child) {
          print('rebuilding $suit......');

          return foundation == null
              ? Container()
              : SuitFoundation(
                  height: mediaQuery.size.height,
                  isLandscape: mediaQuery.orientation == Orientation.landscape,
                  foundation: foundation,
                  width: mediaQuery.size.width,
                  suit: CardModel.fetchSuit(suit),
                  position: position,
                  gameInitial:
                      Provider.of<Game>(context, listen: false).initial);
        },
        shouldRebuild: (previous, next) {
          if (previous == null) {
            return true;
          }
          return previous['rank'] != next['rank'];
        });
  }

  Selector<Game, List> buildCardColumn(int index, BuildContext context) {
    return Selector<Game, List>(
      selector: (_ctx, game) =>
          game.columns.isNotEmpty ? game.columns[index] : null,
      builder: (_ctx, columnsData, _child) {
        return columnsData == null
            ? Container()
            : CardColumn(
                gameInitial: Provider.of<Game>(context, listen: false).initial,
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
    builder: (BuildContext _context) {
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
