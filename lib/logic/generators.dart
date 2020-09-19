import 'dart:math';

import 'card.dart';

enum HandClassification {
  HighCard,
  Pair,
  TwoPair,
  ThreeOfKind,
  Straight,
  Flush,
  FullHouse,
  FourOfKind,
  StraightFlush,
  RoyalFlush,
}

List<int> _sorted(Iterable<Card> cards) {
  List<int> sorted = cards.map((e) => e.ordinal.index).toList();
  sorted.sort((a, b) => a.compareTo(b));
  return sorted;
}

int _highCardValue(Iterable<Card> cards) {
  return _sorted(cards).last;
}

int compare(List<Card> lhs, List<Card> rhs) {
  List<int> left = handClassification(lhs);
  List<int> right = handClassification(rhs);
  for (int ix in Iterable.generate(min(left.length, right.length))) {
    int l = left[ix];
    int r = right[ix];
    if (l < r) return -1;
    if (l > r) return 1;
  }
  return 0;
}

List<int> handClassification(List<Card> cards) {
  List<Card> hand = checkRoyalFlush(cards);
  if (hand != null) {
    return [HandClassification.RoyalFlush.index, _highCardValue(hand)];
  }
  hand = checkStraightFlush(cards);
  if (hand != null) {
    return [HandClassification.StraightFlush.index, _highCardValue(hand)];
  }
  hand = checkFourOfKind(cards);
  if (hand != null) {
    Ordinal ordinal = hand.first.ordinal;
    return [
      HandClassification.FourOfKind.index,
      ordinal.index,
      _highCardValue(cards.where((element) => element.ordinal != ordinal)),
    ];
  }
  hand = checkFullHouse(cards);
  if (hand != null) {
    return [
      HandClassification.FullHouse.index,
      hand.first.ordinal.index,
      hand.last.ordinal.index,
    ];
  }
  hand = checkFlush(cards);
  if (hand != null) {
    return [HandClassification.Flush.index] + _sorted(hand).reversed.toList();
  }
  hand = checkStraight(cards);
  if (hand != null) {
    return [HandClassification.Straight.index] + _sorted(hand).reversed.toList();
  }
  hand = checkThreeOfKind(cards);
  if (hand != null) {
    List<Card> extra = List.from(cards);
    extra.removeWhere((element) => hand.contains(element));
    extra.removeRange(2, extra.length);
    return [HandClassification.ThreeOfKind.index] + _sorted(extra).reversed.toList();
  }
  hand = checkTwoPair(cards);
  if (hand != null) {
    List<int> ords = _sorted(hand);
    List<Card> extra = List.from(cards);
    extra.removeWhere((element) => hand.contains(element));
    List<int> extras = _sorted(extra);
    return [HandClassification.TwoPair.index] + [ords.last, ords.first, extra.length];
  }
  hand = checkTwoOfKind(cards);
  if (hand != null) {
    List<Card> extra = List.from(cards);
    extra.removeWhere((element) => hand.contains(element));
    List<int> extras = _sorted(extra);
    extras = extras.reversed.toList()..removeRange(3, extras.length);
    return [HandClassification.Pair.index] + [hand.first.ordinal.index] + extras;
  }
  List<int> ords = _sorted(cards);
  ords.removeRange(5, ords.length);
  return [HandClassification.HighCard.index] + ords.reversed.toList();
}
