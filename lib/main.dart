import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solitaire_app/widgets/suit_foundation.dart';

import 'widgets/card_column.dart';
import 'widgets/playing_card.dart';
import 'widgets/deck_widget.dart';

import 'providers/game.dart';
import 'models/card_model.dart';

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
  @override
  Widget build(BuildContext context) {
    Color gradientStart =
        Colors.deepPurple[700]; //Change start gradient color here
    Color gradientEnd = Colors.purple[500]; //Change end gradient color here

    final mediaQuery = MediaQuery.of(context);
    final gameProvider = Provider.of<Game>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.purple,
      body: FutureBuilder(
        future: gameProvider.fetchAndLoadGame(),
        builder: (ctx, gameSnapshot) =>
            gameSnapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
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
                          padding: EdgeInsets.all(10),
                          child: Container(
                            height: 500,
                            child: Stack(
                              overflow: Overflow.visible,
                              children: [
                                InkWell(
                                  onTap: gameProvider.pushChangeEvent,
                                  child: CardWidget(
                                    card: CardModel(played: false),
                                    width: mediaQuery.size.width,
                                  ),
                                ),
                                Container(
                                  width: 180,
                                  height: 110,
                                  child: Selector<Game, List>(
                                    selector: (ctx, game) => game.deck,
                                    builder: (ctx, game, child) {
                                      print("BUILD DECK");
                                      return game.isEmpty
                                          ? Container()
                                          : DeckWidget(
                                              deck: game,
                                              mediaQuery: mediaQuery);
                                    },
                                  ),
                                ),
                                buildCardColumn(0, context),
                                buildCardColumn(1, context),
                                buildCardColumn(2, context),
                                buildCardColumn(3, context),
                                buildCardColumn(4, context),
                                buildCardColumn(5, context),
                                buildCardColumn(6, context),
                                buildFoundation(mediaQuery, 'spade', 0,
                                    gameProvider.deck.length),
                                buildFoundation(mediaQuery, 'club', 1,
                                    gameProvider.deck.length),
                                buildFoundation(mediaQuery, 'diamond', 2,
                                    gameProvider.deck.length),
                                buildFoundation(mediaQuery, 'heart', 3,
                                    gameProvider.deck.length),
                              ],
                            ),
                          )),
                    ),
                  ),
      ),
    );
  }

  Selector<Game, Map> buildFoundation(MediaQueryData mediaQuery, String suit,
          int position, int deckLength) =>
      Selector<Game, Map>(selector: (ctx, game) {
        return (game.foundation[suit] != null) ? game.foundation[suit] : null;
      }, builder: (ctx, foundation, child) {
        print('rebuilding $suit......');

        return foundation == null
            ? Container()
            : SuitFoundation(
                foundation: foundation,
                width: mediaQuery.size.width,
                suit: CardModel.fetchSuit(suit),
                position: position,
              );
      }, shouldRebuild: (previous, next) {
        if (previous == null) {
          return true;
        }
        return previous['rank'] != next['rank'];
      });

  Selector<Game, List> buildCardColumn(int index, BuildContext context) {
    return Selector<Game, List>(
      selector: (ctx, game) =>
          game.columns.isNotEmpty ? game.columns[index] : null,
      builder: (ctx, columnsData, child) {
        print('BUILDING COLUMNS+++$index');

        return columnsData == null
            ? Container()
            : CardColumn(
                cards: columnsData,
                columnIndex: index,
                width: MediaQuery.of(context).size.width);
      },
    );
  }
}
