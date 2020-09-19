import 'package:flutter_test/flutter_test.dart';
import 'package:poker/logic/card.dart';
import 'package:poker/logic/generators.dart';

import 'util/matchers.dart';

Card card(int ordinal, [Suit suit = Suit.Spade]) {
  Ordinal ord = Ordinal.values[ordinal - 2];
  return Card(ordinal: ord, suit: suit);
}

void main() {
  group('Hand comparisons', () {
    test('simple hand comparisons', () {
      List<List<Card>> hands = [
        [card(2), card(4), card(7), card(8), card(9, Suit.Heart)], // High card 9
        [card(2), card(4), card(7), card(8), card(11, Suit.Heart)], // High card Jack
        [card(2, Suit.Heart), card(2), card(7), card(8), card(9, Suit.Heart)], // pair of 2s, 9 high
        [card(2, Suit.Heart), card(2), card(7), card(8), card(11, Suit.Heart)], // pair of 2s, 11 high
        [card(3, Suit.Heart), card(3), card(6), card(8), card(9, Suit.Heart)], // pair of 3s, 9,8,6 high
        [card(3, Suit.Heart), card(3), card(7), card(8), card(9, Suit.Heart)], // pair of 2s 9,8,7 high
        [card(4, Suit.Heart), card(4, Suit.Diamond), card(4), card(8), card(9, Suit.Heart)], // three 4s, 9 high
        [card(4, Suit.Heart), card(4, Suit.Diamond), card(4), card(8), card(10, Suit.Heart)], // three of 4s 10 high
        [card(4, Suit.Heart), card(4, Suit.Diamond), card(4), card(9), card(11, Suit.Heart)], // three of 4s 10,9 high
        [card(4), card(5), card(6), card(7), card(8, Suit.Heart)], // straight starting at 4
        [card(10), card(9), card(6), card(7), card(8, Suit.Heart)], // straight starting at 6
        [card(3), card(5), card(6), card(7), card(9)], // flush 9 high
        [card(4), card(5), card(6), card(7), card(9)], // flush 9 high (higher low)
        [card(4), card(5), card(6), card(7), card(12)], // flush queen high
        [card(6, Suit.Heart), card(6, Suit.Diamond), card(6), card(8, Suit.Heart), card(8)], // full house 6 on 8s
        [
          card(6, Suit.Heart),
          card(6, Suit.Diamond),
          card(8, Suit.Diamond),
          card(8, Suit.Heart),
          card(8)
        ], // full house 8 on 6s
        [card(6, Suit.Heart), card(6, Suit.Diamond), card(6, Suit.Club), card(6), card(9)], // 4 of a kind 6s, 9 high
        [card(6, Suit.Heart), card(6, Suit.Diamond), card(6, Suit.Club), card(6), card(10)], // 4 of a kind 6s, 10 high
        [card(4), card(5), card(6), card(7), card(8)], // straight flush starting at 4
        [card(10), card(9), card(6), card(7), card(8)], // straight flush starting at 6
        [card(10), card(11), card(12), card(13), card(14)], // royal flush
      ];

      for (int ix in Iterable.generate(hands.length)) {
        for (int iy in Iterable.generate(hands.length)) {
          expect(compare(hands[ix], hands[iy]), ix.compareTo(iy), reason: '${hands[ix]} < ${hands[iy]} like $ix < $iy');
        }
      }
    });
  });
}
