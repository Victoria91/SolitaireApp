import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final mediaQuery = MediaQuery.of(context);
    final gameProvider = Provider.of<Game>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.green,
      body: FutureBuilder(
        future: gameProvider.fetchAndLoadGame(),
        builder: (ctx, gameSnapshot) => gameSnapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      height: 500,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: gameProvider.pushChangeEvent,
                                child: CardWidget(
                                  card: CardModel(played: false),
                                  width: mediaQuery.size.width,
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                width: 200,
                                height: 110,
                                child: Selector<Game, List>(
                                  selector: (ctx, game) => game.deck,
                                  builder: (ctx, game, child) {
                                    print("BUILD DECK");
                                    return game.isEmpty
                                        ? Container()
                                        : DeckWidget(
                                            deck: game, mediaQuery: mediaQuery);
                                  },
                                ),
                              ),
                            ],
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                          Expanded(
                            child: Selector<Game, List>(
                              selector: (ctx, game) => game.columns,
                              builder: (ctx, columnsData, child) {
                                print('BUILDING COLUMNS+++');
                                return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: columnsData
                                        .asMap()
                                        .entries
                                        .map((columnCards) => CardColumn(
                                              cards: columnCards.value,
                                              columnIndex: columnCards.key,
                                            ))
                                        .toList());
                              },
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
      ),
    );
  }
}
