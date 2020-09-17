import 'package:flutter/material.dart';
import 'package:solitaire_app/models/card_model.dart';
import 'package:solitaire_app/widgets/card_column.dart';

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
    _channel.on("say", _say);

    // Make the request to the server to join the channel
    _channel.join().receive("ok", (response) {
      setState(() {
        cards = response['data']
            .map((res) => (res['cards'])
                .map((card) =>
                    CardModel.initFormServer(card[0], card[1].toString()))
                .toList()
                .cast<CardModel>())
            .toList()
            .cast<List<CardModel>>();
      });

      // _channel.push(event: "can_move", payload: {'from': 1, 'to': 2});
    });
  }

  _say(payload, _ref, _joinRef) {
    print('result');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: (cards != null ? cards : [])
                .map((columnCards) => CardColumn(columnCards))
                .toList()),
      ),
    );
  }
}
