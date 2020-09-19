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
  final socket = PhoenixSocket("ws://localhost:4000/socket/websocket");

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PhoenixChannel _channel;
  List<List<CardModel>> cards;

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
      // _channel.push(event: "can_move", payload: {'from': 1, 'to': 2});
    });
  }

  _setCardState(Map response) {
    setState(() {
      cards = response['data']
          .map((res) {
            return res['cards']
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
                .cast<CardModel>();
          })
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

  _updateGameScreen(payload, _ref, _joinRef) {
    _setCardState(payload);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: Colors.green,
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CardWidget(
                  card: CardModel(played: false),
                  width: mediaQuery.size.width,
                )
              ],
            ),
            Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: (cards != null ? cards : [])
                      .asMap()
                      .entries
                      .map((columnCards) => CardColumn(
                          columnCards.value, columnCards.key, _pushMoveEvent))
                      .toList()),
            ),
          ],
        ),
      ),
    );
  }
}
