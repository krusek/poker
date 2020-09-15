import 'package:flutter_test/flutter_test.dart';
import 'package:poker/logic/card.dart';

import 'util/matchers.dart';

void main() {
  group('Royal flush tests', () {
    test('Not a royal flush', () {
      List<Card> cards = [
        Card(ordinal: Ordinal.Ace, suit: Suit.Club),
        Card(ordinal: Ordinal.King, suit: Suit.Diamond),
        Card(ordinal: Ordinal.Four, suit: Suit.Spade),
        Card(ordinal: Ordinal.Six, suit: Suit.Club),
        Card(ordinal: Ordinal.Seven, suit: Suit.Club),
        Card(ordinal: Ordinal.Eight, suit: Suit.Club),
      ];
      expect(checkRoyalFlush(cards), null);
    });
    test('Royal straight but not flush', () {
      List<Card> cards = [
        Card(ordinal: Ordinal.Ace, suit: Suit.Club),
        Card(ordinal: Ordinal.King, suit: Suit.Diamond),
        Card(ordinal: Ordinal.Queen, suit: Suit.Spade),
        Card(ordinal: Ordinal.Jack, suit: Suit.Club),
        Card(ordinal: Ordinal.Ten, suit: Suit.Club),
      ];
      expect(checkRoyalFlush(cards), null);
    });
    test('flush but not royal', () {
      List<Card> cards = [
        Card(ordinal: Ordinal.King, suit: Suit.Club),
        Card(ordinal: Ordinal.Queen, suit: Suit.Club),
        Card(ordinal: Ordinal.Jack, suit: Suit.Club),
        Card(ordinal: Ordinal.Ten, suit: Suit.Club),
        Card(ordinal: Ordinal.Nine, suit: Suit.Club),
      ];
      expect(checkRoyalFlush(cards), null);
    });
    test('Simple Royal flush', () {
      List<Card> cards = createFlush(suit: Suit.Diamond);
      List<Card> f = checkRoyalFlush(cards);
      expect(f, RoyalFlushMatcher(suit: Suit.Diamond));
    });
    test('reversed Royal flush', () {
      List<Card> cards = createFlush(suit: Suit.Heart).reversed.toList();
      List<Card> f = checkRoyalFlush(cards);
      expect(f, RoyalFlushMatcher(suit: Suit.Heart));
    });
    test('unordered Royal flush', () {
      List<Card> cards = createFlush(suit: Suit.Spade);
      cards.shuffle();
      List<Card> f = checkRoyalFlush(cards);
      expect(f, RoyalFlushMatcher(suit: Suit.Spade));
    });
    test('unordered Royal flush with extra cards', () {
      List<Card> cards = createFlush(suit: Suit.Club)
        ..add(Card(ordinal: Ordinal.Five, suit: Suit.Spade))
        ..add(Card(ordinal: Ordinal.Four, suit: Suit.Diamond))
        ..add(Card(ordinal: Ordinal.Seven, suit: Suit.Heart))
        ..add(Card(ordinal: Ordinal.Three, suit: Suit.Spade));
      cards.shuffle();
      List<Card> f = checkRoyalFlush(cards);
      expect(f, RoyalFlushMatcher(suit: Suit.Club));
    });
  });
}
