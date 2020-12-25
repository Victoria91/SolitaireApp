import 'package:equatable/equatable.dart';

class ApiSuitFoundation extends Equatable {
  final List from;
  final dynamic prev;
  final dynamic rank;

  ApiSuitFoundation({
    this.from,
    this.rank,
    this.prev,
  });

  List<Object> get props => [from, rank, prev];

  ApiSuitFoundation.fromApi(Map response)
      : from = response['from'],
        prev = response['prev'],
        rank = response['rank'];

  @override
  String toString() {
    return 'rank: $rank -- prev: $prev -- from: $from \n';
  }
}
