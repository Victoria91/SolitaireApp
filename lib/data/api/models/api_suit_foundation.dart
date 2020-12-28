import 'package:equatable/equatable.dart';

class ApiSuitFoundation extends Equatable {
  const ApiSuitFoundation({
    this.from,
    this.rank,
    this.prev,
  });

  ApiSuitFoundation.fromApi(Map response)
      : from = response['from'],
        prev = response['prev'],
        rank = response['rank'];

  final List from;
  final dynamic prev;
  final dynamic rank;

  @override
  List<Object> get props => [from, rank, prev];

  @override
  String toString() {
    return 'rank: $rank -- prev: $prev -- from: $from \n';
  }
}
