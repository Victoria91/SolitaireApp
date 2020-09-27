import 'package:flutter/material.dart';

import 'package:solitaire_app/models/card_model.dart';
import 'package:solitaire_app/widgets/card_column.dart';
import './widgets/playing_card.dart';

import './models/card_model.dart';
import 'package:phoenix_wings/phoenix_wings.dart';

void main() {
  runApp(MyApp());
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
  // final socket = PhoenixSocket("wss://solitaire.dbykov.com/socket/websocket");
  final socket = PhoenixSocket("ws://localhost:4000/socket/websocket");

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PhoenixChannel _channel;
  List<List<CardModel>> cards;
  List<CardModel> deck;

  int deckLength;

  @override
  void initState() {
    connectSocket();
    super.initState();
  }

  Future connectSocket() async {
    await widget.socket.connect();
    // Create a new PhoenixChannel
    _channel = widget.socket.channel("game");
    // Setup listeners for channel events
    _channel.on("update_game", _updateGameScreen);

    // Make the request to the server to join the channel
    _channel.join().receive("ok", (response) {
      _setCardState(response);
    });
  }

  _setCardState(Map response) {
    setState(() {
      deck = response['deck']
          .map((card) => CardModel.initFromDeck(card[0], card[1].toString()))
          .toList()
          .reversed
          .toList()
          .cast<CardModel>();

      cards = response['columns']
          .map((res) => res['cards']
              .asMap()
              .entries
              .toList()
              .reversed
              .toList()
              .map((card) {
                return CardModel.initFormServer(
                    card.value[0],
                    card.value[1].toString(),
                    res['cards'].length - card.key,
                    res['unplayed']);
              })
              .toList()
              .cast<CardModel>())
          .toList()
          .cast<List<CardModel>>();
    });
  }

  void _pushMoveEvent(int fromColumn, int fromCardIndex, int toColumn) {
    _channel.push(event: "move_to_column", payload: {
      'from_column': fromColumn,
      'from_card_index': fromCardIndex,
      'to_column': toColumn
    }).receive("ok", (response) {
      print('move_to_column response Ok');

      _setCardState(response);
    }).receive("error", (response) {
      print('Can not move card!');
    });
  }

  void _pushChangeEvent() {
    _channel.push(event: "change").receive("ok", (response) {
      print('change response Ok');

      _setCardState(response);
    });
  }

  _updateGameScreen(payload, _ref, _joinRef) {
    _setCardState(payload);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: Colors.green,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            height: 500,
            child: Column(
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        print('tapped');
                        _pushChangeEvent();
                      },
                      child: CardWidget(
                        card: CardModel(played: false),
                        width: mediaQuery.size.width,
                      ),
                    ),
                    SizedBox(width: 10),
                    if (deck != null && deck.isNotEmpty)
                      Container(
                        width: 200,
                        height: 110,
                        child: Stack(
                            overflow: Overflow.visible,
                            children: deck.asMap().entries.map((card) {
                              final cardWidget = CardWidget(
                                width: mediaQuery.size.width,
                                card: card.value,
                              );
                              return Positioned(
                                  left: (card.key * 20).toDouble(),
                                  child: (true)
                                      ? Draggable(
                                          feedback: cardWidget,
                                          childWhenDragging: Container(),
                                          child: cardWidget,
                                        )
                                      : cardWidget);
                            }).toList()),
                      ),
                  ],
                ),
                Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                Expanded(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: (cards != null ? cards : [])
                          .asMap()
                          .entries
                          .map((columnCards) => CardColumn(columnCards.value,
                              columnCards.key, _pushMoveEvent))
                          .toList()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
