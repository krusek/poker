import 'package:flutter_test/flutter_test.dart';
import 'package:poker/logic/card.dart';

/// Checks the equality of two lists of cards.
/// Assumes no cards are duplicated and is
/// independent of order.
bool equalHands(List<Card> lhs, List<Card> rhs) {
  if (lhs.length != rhs.length) return false;
  for (Card card in lhs) {
    if (!rhs.contains(card)) return false;
  }
  return true;
}

List<Card> createFlush({Suit suit}) {
  return [
    Card(ordinal: Ordinal.Ace, suit: suit),
    Card(ordinal: Ordinal.King, suit: suit),
    Card(ordinal: Ordinal.Queen, suit: suit),
    Card(ordinal: Ordinal.Jack, suit: suit),
    Card(ordinal: Ordinal.Ten, suit: suit),
  ];
}

class RoyalFlushMatcher extends Matcher {
  final Suit suit;
  final List<Card> flush;
  RoyalFlushMatcher({this.suit}) : this.flush = createFlush(suit: suit);
  @override
  Description describe(Description description) {
    return description.add('is Royal Flush of suit $suit');
  }

  @override
  bool matches(item, Map matchState) {
    if (item is List<Card>) {
      return equalHands(item, flush);
    }
    return false;
  }
}
