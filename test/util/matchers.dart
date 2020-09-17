import 'package:flutter_test/flutter_test.dart';
import 'package:poker/logic/card.dart';

/// Checks the equality of two lists of cards.
/// Assumes no cards are duplicated and is
/// independent of order.
bool equalHands(List<Card> lhs, List<Card> rhs) {
  if (lhs == rhs) return true;
  if (lhs == null || rhs == null) return false;
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

List<Card> createStraightFlush({Suit suit, Ordinal low}) {
  final index = low.index;
  final values = Ordinal.values;
  return [
    Card(ordinal: values[index + 4], suit: suit),
    Card(ordinal: values[index + 3], suit: suit),
    Card(ordinal: values[index + 2], suit: suit),
    Card(ordinal: values[index + 1], suit: suit),
    Card(ordinal: values[index], suit: suit),
  ];
}

class EqualHandsMatcher extends Matcher {
  final List<Card> hand;
  EqualHandsMatcher({this.hand});
  @override
  Description describe(Description description) {
    return description.add('cards equal $hand');
  }

  @override
  bool matches(item, Map matchState) {
    return equalHands(item, hand);
  }
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

class StraightFlushMatcher extends Matcher {
  final Suit suit;
  final Ordinal low;
  final List<Card> straight;
  StraightFlushMatcher({this.suit, this.low})
      : assert(low.index < Ordinal.Ten.index),
        straight = createStraightFlush(suit: suit, low: low);
  @override
  Description describe(Description description) {
    return description.add('is Straight Flush of suit $suit starting at $low');
  }

  @override
  bool matches(item, Map matchState) {
    if (item is List<Card>) {
      return equalHands(item, straight);
    }
    return false;
  }
}
