import 'package:flutter/material.dart';
import 'package:phoenix_wings/phoenix_wings.dart';

import '../models/card_model.dart';

class Game with ChangeNotifier {
  final socket = PhoenixSocket("wss://solitaire.dbykov.com/socket/websocket");

  // final socket = PhoenixSocket("ws://localhost:4000/socket/websocket");
  PhoenixChannel _channel;

  List<List<CardModel>> _columns = [];
  List<CardModel> _deck = [];

  List<List<CardModel>> get columns {
    return _columns;
  }

  List<CardModel> get deck {
    return _deck;
  }

  Future<void> fetchAndLoadGame() async {
    await socket.connect();
    // Create a new PhoenixChannel
    _channel = socket.channel("game");
    // Setup listeners for channel events
    _channel.on("update_game", _updateGameScreen);

    // Make the request to the server to join the channel
    _channel.join().receive("ok", (responseFromServer) {
      print("RECEIVED OK ON JOIN");
      _setCardStateColumns(responseFromServer);
      _setCardStateDeck(responseFromServer);
    });
  }

  void pushMoveFromColumnEvent(
      int fromColumn, int fromCardIndex, int toColumn) {
    _channel.push(event: "move_from_column", payload: {
      'from_column': fromColumn,
      'from_card_index': fromCardIndex,
      'to_column': toColumn
    }).receive("ok", (responseFromServer) {
      print(responseFromServer);
      print('move_from_column response Ok');

      _setCardStateColumns(responseFromServer);

      _setCardStateDeck(responseFromServer);
    }).receive("error", (response) {
      print('Can not move card!');
    });
  }

  void pushMoveFromDeckEvent(int toColumn) {
    _channel.push(
        event: "move_from_deck",
        payload: {'to_column': toColumn}).receive("ok", (response) {
      print('move_from_deck response Ok');

      _setCardStateColumns(response);
      _setCardStateDeck(response);
    }).receive("error", (response) {
      print('Can not move from deck card!');
    });
  }

  void pushChangeEvent() {
    _channel.push(event: "change").receive("ok", (responseFromServer) {
      print('change response Ok');

      _setCardStateDeck(responseFromServer);
      _setCardStateColumns(responseFromServer);

      print(DateTime.now().millisecondsSinceEpoch);
    });
  }

  void _setCardStateDeck(Map response) {
    print('received _setCardState');
    _deck = response['deck']
        .map((card) => CardModel.initFromDeck(card[0], card[1].toString()))
        .toList()
        .reversed
        .toList()
        .cast<CardModel>();

    notifyListeners();
  }

  void _setCardStateColumns(Map response) {
    _columns = response['columns']
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

    notifyListeners();
  }

  _updateGameScreen(payload, _ref, _joinRef) {
    print('received _updateGameScreen+++');
    _setCardStateDeck(payload);
    _setCardStateColumns(payload);
  }
}
