import 'package:flutter/material.dart';
import 'package:phoenix_wings/phoenix_wings.dart';
import 'package:http/http.dart' as http;

import 'package:solitaire_app/services/token_storage.dart';
import '../models/card_model.dart';
import '../constants.dart';

class Game with ChangeNotifier {
  final socket = PhoenixSocket("ws$hostUrlPath/socket/websocket");

  PhoenixChannel _channel;

  List<List<CardModel>> _columns = [];
  List<CardModel> _deck = [];
  // if game has just started (needed for animation condition)
  bool _initial = false;

  int _deckLength = 0;

  int activeColumnIndex;

  bool _win = false;

  String _deviceToken;

  Map<String, Map> _foundation = {
    'club': {},
    'diamond': {},
    'spade': {},
    'heart': {}
  };

  List<List<CardModel>> get columns => _columns;

  Map<String, Map> get foundation => _foundation;

  List<CardModel> get deck => _deck;

  int get deckLength => _deckLength;

  bool get initial => _initial;

  bool get win => _win;

  void setActiveColumnIndex(int index) {
    activeColumnIndex = index;
    notifyListeners();
  }

  void startNewGame() {
    setInitial(true);
    _updateWinState(false);

    _channel.push(event: 'start_new_game').receive('ok', (response) {
      _setCardStateDeck(response);
      _setCardStateColumns(response);
      _setCardStateFoundation(response);
    });
  }

  void unsetActiveColumnIndex() {
    activeColumnIndex = null;
    notifyListeners();
  }

  Future<void> fetchAndLoadGame() async {
    await socket.connect();

    _deviceToken = await TokenStorage.getDeviceToken();
    print('tokenn======= $_deviceToken');

    // Create a new PhoenixChannel
    _channel = socket.channel('game:$_deviceToken');
    // Setup listeners for channel events
    _channel.on('update_game', _updateGameScreen);
    _channel.on('win', (_payload, _ref, _joinRef) {
      _updateWinState(true);
    });

    // Make the request to the server to join the channel
    _channel.join().receive('ok', (responseFromServer) {
      print('RECEIVED OK ON JOIN');
      _setCardStateColumns(responseFromServer);
      _setCardStateDeck(responseFromServer);
      _setCardStateFoundation(responseFromServer);
    });
  }

  void _updateWinState(bool newWin) {
    _win = newWin;
    notifyListeners();
  }

  void setInitial([bool initial = false]) {
    _initial = initial;
    notifyListeners();
  }

  void pushMoveFromColumnEvent(
      int fromColumn, int fromCardIndex, int toColumn) {
    _channel.push(event: 'move_from_column', payload: {
      'from_column': fromColumn,
      'from_card_index': fromCardIndex,
      'to_column': toColumn
    }).receive('ok', (responseFromServer) {
      print(responseFromServer);
      print('move_from_column response Ok');

      _setCardStateColumns(responseFromServer);
      _setCardStateDeck(responseFromServer);
    }).receive('error', (responseFromServer) {
      _setCardStateColumns(responseFromServer);

      print('Can not move card!');
    });
  }

  void pushMoveFromDeckEvent(int toColumn) {
    _channel.push(
        event: 'move_from_deck',
        payload: {'to_column': toColumn}).receive('ok', (response) {
      print('move_from_deck response Ok');

      _setCardStateColumns(response);
      _setCardStateDeck(response);
    }).receive('error', (response) {
      print('Can not move from deck card!');
    });
  }

  void pushMoveFromFoundation(String suit, int toColumn) {
    _channel.push(event: 'move_from_foundation', payload: {
      'to_column': toColumn,
      'suit': suit
    }).receive('ok', (response) {
      print('move_from_foundation response Ok');

      _setCardStateColumns(response);
      _setCardStateFoundation(response, true);
    }).receive('error', (response) {
      print('Can not move from foundation!');
    });
  }

  void pushChangeEvent() {
    _channel.push(event: 'change').receive('ok', (responseFromServer) {
      print('change response Ok');

      _setCardStateDeck(responseFromServer);
      _setCardStateColumns(responseFromServer);
      unsetActiveColumnIndex();
    });
  }

  void pushMoveToFoundationFromColumnEvent(columnIndex) {
    _channel.push(event: 'move_to_foundation_from_column', payload: {
      'from_column': columnIndex
    }).receive('ok', (responseFromServer) {
      print('pushMoveToFoundationEvent response Ok');

      _setCardStateColumns(responseFromServer);
      _setCardStateFoundation(responseFromServer, true);

      print(DateTime.now().millisecondsSinceEpoch);
    });
  }

  void pushMoveToFoundationFromDeckEvent() {
    _channel.push(event: 'move_to_foundation_from_deck').receive('ok',
        (responseFromServer) {
      print('pushMoveToFoundationEvent response Ok');

      _setCardStateDeck(responseFromServer);
      _setCardStateFoundation(responseFromServer, true);

      print(DateTime.now().millisecondsSinceEpoch);
    });
  }

  void setColumns(int index, List<CardModel> cards) {
    _columns[index] = cards;
    notifyListeners();
  }

  void unsetColumnNewCard(int columnIndex) {
    final lastCard = _columns[columnIndex].last;
    _columns[columnIndex].last = CardModel(
        newCard: false,
        suit: lastCard.suit,
        rank: lastCard.rank,
        played: lastCard.played);
  }

  void takeCardFromDeck() {
    _deck = _deck.take(deck.length - 1).toList();
    notifyListeners();
  }

  void setDeck(List<CardModel> cards) {
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

    _deckLength = response['deck_length'];

    notifyListeners();
  }

  void _setCardStateColumns(Map response) {
    _columns = response['columns']
        .asMap()
        .entries
        .map((res) => res.value['cards']
            .asMap()
            .entries
            .toList()
            .reversed
            .toList()
            .map((card) => CardModel.initFormServer(
                card.value[0],
                card.value[1].toString(),
                res.value['cards'].length - card.key,
                res.value['unplayed'],
                card.key == 0 &&
                    _columns.isNotEmpty &&
                    cardHadTurnedOver(res.value['cards'], _columns[res.key])))
            .toList()
            .cast<CardModel>())
        .toList()
        .cast<List<CardModel>>();

    notifyListeners();
  }

  bool cardHadTurnedOver(currentCardColumn, previousCardColumn) {
    return previousCardColumn.length == currentCardColumn.length &&
        previousCardColumn.last.played == false;
  }

  void _setCardStateFoundation(Map response, [bool manual = false]) {
    ['club', 'diamond', 'heart', 'spade'].forEach((suit) {
      final responseBySuit = response['foundation'][suit];
      int fromCardIndex;
      final fromResponseBySuit = responseBySuit['from'];
      if (fromResponseBySuit != null && fromResponseBySuit[0] == 'column') {
        fromCardIndex =
            response['columns'][fromResponseBySuit[1]]['cards'].length + 1;
      }

      foundation[suit] = (responseBySuit['rank'] == null)
          ? {}
          : {
              'prev': responseBySuit['prev'] == null
                  ? null
                  : CardModel.initFromDeck(suit, responseBySuit['prev']),
              'from': fromResponseBySuit,
              'cardIndex': fromCardIndex,
              'deckLength': response['deck'].length,
              'manual': manual,
              'changed': responseBySuit['rank'] != foundation[suit]['rank'] &&
                  foundation[suit].isNotEmpty,
              'rank': CardModel.initFromDeck(suit, responseBySuit['rank'])
            };
    });

    notifyListeners();
  }

  void unsetChanged() {
    ['club', 'diamond', 'heart', 'spade'].forEach((element) {
      foundation[element].addAll({'changed': false});
    });

    notifyListeners();
  }

  _updateGameScreen(payload, _ref, _joinRef) {
    print('received _updateGameScreen+++');

    _setCardStateDeck(payload);
    _setCardStateColumns(payload);
    _setCardStateFoundation(payload);
  }

  Future<bool> canMove(List<String> to, List<String> from) async {
    var client = http.Client();
    try {
      final response = await client.get(
          'http$hostUrlPath/can_move?to_suit=${to[0]}&to_rank=${to[1]}&from_suit=${from[0]}&from_rank=${from[1]}');

      return response.body == 'true';
    } finally {
      client.close();
    }
  }
}
