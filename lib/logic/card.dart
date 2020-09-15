enum Suit { Heart, Diamond, Spade, Club }

enum Ordinal { Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King, Ace }

class Card {
  final Suit suit;
  final Ordinal ordinal;
  const Card({this.suit, this.ordinal});

  bool operator ==(Object card) {
    if (card is Card) {
      return suit == card.suit && ordinal == card.ordinal;
    }
    return false;
  }

  @override
  int get hashCode => (4 * ordinal.index + suit.index).hashCode;

  @override
  String toString() {
    return '$ordinal of $suit';
  }
}

/// The different kinds of hands are as follows:
/// Royal Flush
/// Straight Flush
/// Four of a kind
/// Full House
/// Flush
/// Straight
/// Three of a kind
/// Two Pair
/// A Pair
/// High Card

List<Card> checkStraightFlush(List<Card> cards) {
  cards.sort((lhs, rhs) {
    final suitComp = lhs.suit.index.compareTo(rhs.suit.index);
    if (suitComp != 0) return suitComp;
    return rhs.ordinal.index.compareTo(lhs.ordinal.index);
  });
  Ordinal _previous(Ordinal ordinal) {
    if (ordinal == Ordinal.Two) return null;
    return Ordinal.values[ordinal.index - 1];
  }

  Suit suit;
  List<Card> rValue = List();
  Ordinal expected;
  for (Card card in cards) {
    if (card.ordinal == expected && card.suit == suit) {
      rValue.add(card);
      if (rValue.length == 5) {
        return rValue;
      }
      expected = _previous(card.ordinal);
    } else {
      rValue = [card];
      suit = card.suit;
      expected = _previous(card.ordinal);
    }
  }
  return null;
}

List<Card> checkRoyalFlush(List<Card> cards) {
  cards.sort((lhs, rhs) {
    final suitComp = lhs.suit.index.compareTo(rhs.suit.index);
    if (suitComp != 0) return suitComp;
    return rhs.ordinal.index.compareTo(lhs.ordinal.index);
  });
  Suit suit;
  List<Ordinal> ordinals = [Ordinal.Ace, Ordinal.King, Ordinal.Queen, Ordinal.Jack, Ordinal.Ten];
  List<Card> rValue = List();
  int expected = 0;
  for (Card card in cards) {
    if (expected == 0) suit = card.suit;
    if (card.ordinal == ordinals[expected] && card.suit == suit) {
      rValue.add(card);
      expected++;
      if (expected == 5) {
        return rValue;
      }
    } else if (card.ordinal == Ordinal.Ace) {
      rValue = [card];
      suit = card.suit;
      expected = 1;
    } else {
      rValue = [];
      suit = null;
      expected = 0;
    }
  }
  return null;
}
