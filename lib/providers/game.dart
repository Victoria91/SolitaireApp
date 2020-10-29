import 'package:flutter/material.dart';
import 'package:phoenix_wings/phoenix_wings.dart';

import '../models/card_model.dart';

import 'package:http/http.dart' as http;

class Game with ChangeNotifier {
  static const host_path = 'solitaire.dbykov.com';
  final socket = PhoenixSocket("wss://$host_path/socket/websocket");

  // final socket = PhoenixSocket("ws://localhost:4000/socket/websocket");
  PhoenixChannel _channel;

  List<List<CardModel>> _columns = [];
  List<CardModel> _deck = [];
  // if game has just started (needed for animation condition)
  bool initial = true;
  List<List<CardModel>> get columns {
    return _columns;
  }

  int activeColumnIndex;

  List<CardModel> get deck {
    return _deck;
  }

  void setActiveColumnIndex(int index) {
    activeColumnIndex = index;
    notifyListeners();
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
      _setCardStateColumns(responseFromServer, false);
      _setCardStateDeck(responseFromServer);
    });
  }

  void unSetInitial() {
    initial = false;
    notifyListeners();
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
    }).receive("error", (responseFromServer) {
      _setCardStateColumns(responseFromServer);

      print('Can not move card!');
    });
  }

  void pushMoveFromDeckEvent(int toColumn) {
    notifyListeners();
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

  void emptyColumn(int index) {
    _columns[index] = [];
    notifyListeners();
  }

  void setColumns(int index, List<CardModel> cards) {
    _columns[index] = cards;
    notifyListeners();
  }

  void takeCardFromDeck() {
    _deck = _deck.take(deck.length - 1).toList();
    notifyListeners();
  }

  void setDeck(List<CardModel> cards) {
    print(cards);
    _deck = cards;
    notifyListeners();
  }

  void _setCardStateDeck(Map response) {
    print('received _setCardStateDeck-----------');

    _deck = response['deck']
        .map((card) => CardModel.initFromDeck(card[0], card[1].toString()))
        .toList()
        .reversed
        .toList()
        .cast<CardModel>();

    notifyListeners();
  }

  void _setCardStateColumns(Map response, [bool needUnsetInitial = true]) {
    if (needUnsetInitial) {
      unSetInitial();
    }
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

  Future<bool> canMove(List<String> to, List<String> from) async {
    var client = http.Client();
    try {
      final response = await client.get(
          'https://$host_path/can_move?to_suit=${to[0]}&to_rank=${to[1]}&from_suit=${from[0]}&from_rank=${from[1]}');

      return response.body == 'true';
    } finally {
      client.close();
    }
  }
}
