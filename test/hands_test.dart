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

  group('straight flush tests', () {
    test('Not a straight flush', () {
      List<Card> cards = [
        Card(ordinal: Ordinal.Ace, suit: Suit.Club),
        Card(ordinal: Ordinal.King, suit: Suit.Diamond),
        Card(ordinal: Ordinal.Four, suit: Suit.Spade),
        Card(ordinal: Ordinal.Six, suit: Suit.Club),
        Card(ordinal: Ordinal.Seven, suit: Suit.Club),
        Card(ordinal: Ordinal.Eight, suit: Suit.Club),
      ];
      expect(checkStraightFlush(cards), null);
    });
    test('straight but not flush', () {
      List<Card> cards = [
        Card(ordinal: Ordinal.Ace, suit: Suit.Club),
        Card(ordinal: Ordinal.King, suit: Suit.Diamond),
        Card(ordinal: Ordinal.Queen, suit: Suit.Spade),
        Card(ordinal: Ordinal.Jack, suit: Suit.Club),
        Card(ordinal: Ordinal.Ten, suit: Suit.Club),
      ];
      expect(checkStraightFlush(cards), null);
    });
    test('flush but not straight', () {
      List<Card> cards = [
        Card(ordinal: Ordinal.King, suit: Suit.Club),
        Card(ordinal: Ordinal.Queen, suit: Suit.Club),
        Card(ordinal: Ordinal.Jack, suit: Suit.Club),
        Card(ordinal: Ordinal.Ten, suit: Suit.Club),
        Card(ordinal: Ordinal.Eight, suit: Suit.Club),
      ];
      expect(checkStraightFlush(cards), null);
    });
    test('regular straight flush test', () {
      List<Card> cards = [
        Card(ordinal: Ordinal.King, suit: Suit.Club),
        Card(ordinal: Ordinal.Queen, suit: Suit.Club),
        Card(ordinal: Ordinal.Jack, suit: Suit.Club),
        Card(ordinal: Ordinal.Ten, suit: Suit.Club),
        Card(ordinal: Ordinal.Nine, suit: Suit.Club),
      ];
      expect(checkStraightFlush(cards), StraightFlushMatcher(suit: Suit.Club, low: Ordinal.Nine));
    });
    test('reversed straight flush test', () {
      List<Card> cards = createStraightFlush(suit: Suit.Spade, low: Ordinal.Three).reversed.toList();
      expect(checkStraightFlush(cards), StraightFlushMatcher(suit: Suit.Spade, low: Ordinal.Three));
    });
    test('unordered straight flush test', () {
      List<Card> cards = createStraightFlush(suit: Suit.Spade, low: Ordinal.Three).reversed.toList();
      cards.shuffle();
      expect(checkStraightFlush(cards), StraightFlushMatcher(suit: Suit.Spade, low: Ordinal.Three));
    });
    test('unordered straight flush with extra cards', () {
      List<Card> cards = createStraightFlush(suit: Suit.Spade, low: Ordinal.Three)
        ..add(Card(ordinal: Ordinal.Five, suit: Suit.Heart))
        ..add(Card(ordinal: Ordinal.Four, suit: Suit.Diamond))
        ..add(Card(ordinal: Ordinal.Seven, suit: Suit.Heart))
        ..add(Card(ordinal: Ordinal.Three, suit: Suit.Heart));
      cards.shuffle();
      expect(checkStraightFlush(cards), StraightFlushMatcher(suit: Suit.Spade, low: Ordinal.Three));
    });
    test('selects high straight flush with extra cards', () {
      List<Card> cards = createStraightFlush(suit: Suit.Spade, low: Ordinal.Three)
        ..add(Card(ordinal: Ordinal.Eight, suit: Suit.Spade))
        ..add(Card(ordinal: Ordinal.Nine, suit: Suit.Spade))
        ..add(Card(ordinal: Ordinal.Seven, suit: Suit.Heart))
        ..add(Card(ordinal: Ordinal.Three, suit: Suit.Heart));
      cards.shuffle();
      expect(checkStraightFlush(cards), StraightFlushMatcher(suit: Suit.Spade, low: Ordinal.Five));
    });
  });

  group('4 of a kind', () {
    test('test 4 of a kind', () {
      List<Card> four = [
        Card(ordinal: Ordinal.Queen, suit: Suit.Spade),
        Card(ordinal: Ordinal.Queen, suit: Suit.Club),
        Card(ordinal: Ordinal.Queen, suit: Suit.Diamond),
        Card(ordinal: Ordinal.Queen, suit: Suit.Heart),
      ];
      List<Card> cards = List.from(four)..add(Card(ordinal: Ordinal.Eight, suit: Suit.Club));
      expect(checkFourOfKind(cards), EqualHandsMatcher(hand: four));
    });

    test('test not 4 of a kind', () {
      List<Card> four = [
        Card(ordinal: Ordinal.Queen, suit: Suit.Spade),
        Card(ordinal: Ordinal.Queen, suit: Suit.Club),
        Card(ordinal: Ordinal.Jack, suit: Suit.Diamond),
        Card(ordinal: Ordinal.Queen, suit: Suit.Heart),
      ];
      List<Card> cards = List.from(four)..add(Card(ordinal: Ordinal.Eight, suit: Suit.Club));
      expect(checkFourOfKind(cards), null);
    });
  });

  group('2 of a kind', () {
    test('test 2 of a kind', () {
      List<Card> pair = [
        Card(ordinal: Ordinal.Seven, suit: Suit.Club),
        Card(ordinal: Ordinal.Seven, suit: Suit.Diamond),
      ];
      List<Card> cards = List.from(pair)
        ..add(Card(ordinal: Ordinal.Eight, suit: Suit.Club))
        ..add(Card(ordinal: Ordinal.Queen, suit: Suit.Spade))
        ..add(Card(ordinal: Ordinal.Nine, suit: Suit.Heart));

      expect(checkTwoOfKind(cards), EqualHandsMatcher(hand: pair));
    });

    test('test high 2 of a kind', () {
      List<Card> pair = [
        Card(ordinal: Ordinal.Seven, suit: Suit.Club),
        Card(ordinal: Ordinal.Seven, suit: Suit.Diamond),
      ];
      List<Card> cards = List.from(pair)
        ..add(Card(ordinal: Ordinal.Two, suit: Suit.Club))
        ..add(Card(ordinal: Ordinal.Two, suit: Suit.Spade))
        ..add(Card(ordinal: Ordinal.Nine, suit: Suit.Heart));

      expect(checkTwoOfKind(cards), EqualHandsMatcher(hand: pair));
    });

    test('test not 2 of a kind', () {
      List<Card> hand = [
        Card(ordinal: Ordinal.Nine, suit: Suit.Spade),
        Card(ordinal: Ordinal.Queen, suit: Suit.Club),
        Card(ordinal: Ordinal.Jack, suit: Suit.Diamond),
        Card(ordinal: Ordinal.Two, suit: Suit.Heart),
        Card(ordinal: Ordinal.Eight, suit: Suit.Club),
      ];
      expect(checkTwoOfKind(hand), null);
    });
  });
}
