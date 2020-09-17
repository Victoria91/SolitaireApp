import 'package:flutter/material.dart';
import 'card/title_part.dart';

class PlayingCard extends StatelessWidget {
  final double top;
  final double bottom;
  final bool last;
  final String rank;

  PlayingCard({this.top, this.bottom, this.rank, this.last = false});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;

    print(rank);

    final card = Card2(
      width: width,
      rank: rank,
    );
    return Positioned(
      top: top,
      child: true
          ? Draggable(
              child: card,
              feedback: Material(
                child: card,
                color: Colors.transparent,
              ),
              childWhenDragging: Container(),
            )
          : card,
    );
  }
}

class Card2 extends StatelessWidget {
  final String rank;
  const Card2({
    this.rank,
    @required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width / 8,
        height: width / 7 * 1.15,
        child: Column(children: [
          TitlePart(rank, 'top'),
          Image(
            image: NetworkImage(
                'https://bfa.github.io/solitaire-js/img/face-jack-spade.png'),
            width: 50,
            height: 70,
          ),
          TitlePart(rank, 'down'),
        ]),
        decoration: BoxDecoration(
          border: Border.all(),
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            10,
          ),
        ));
  }
}
