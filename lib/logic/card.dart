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

int _suitFirstComparison(Card lhs, Card rhs) {
  final suitComp = lhs.suit.index.compareTo(rhs.suit.index);
  if (suitComp != 0) return suitComp;
  return rhs.ordinal.index.compareTo(lhs.ordinal.index);
}

int _ordinalFirstComparison(Card lhs, Card rhs) {
  final ordComp = rhs.ordinal.index.compareTo(lhs.ordinal.index);
  if (ordComp != 0) return ordComp;
  return lhs.suit.index.compareTo(rhs.suit.index);
}

List<Card> checkStraightFlush(List<Card> cards) {
  cards.sort(_suitFirstComparison);
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
  cards.sort(_suitFirstComparison);
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

typedef _Checker = List<Card> Function(List<Card>);

List<Card> checkFullHouse(List<Card> cards) {
  return _checkTwoScenarios(cards, checkThreeOfKind, checkTwoOfKind);
}

List<Card> checkTwoPair(List<Card> cards) {
  return _checkTwoScenarios(cards, checkTwoOfKind, checkTwoOfKind);
}

/// Checks the first check, removes those cards and checks the second one. If both checks pass then both lists are
/// returned. Care should be taken regarding the order of the checks. Basically, the more specific check should be
/// the first argument. For example passing checkTwoOfKind and checkThreeOfKind in that order can fail for a full
/// house if the three of a kind has larger numbers.
List<Card> _checkTwoScenarios(List<Card> cards, _Checker firstCheck, _Checker secondCheck) {
  List<Card> first = firstCheck(cards);
  if (first == null) return null;
  List<Card> filtered = cards.where((element) => !first.contains(element));
  List<Card> second = secondCheck(filtered);
  if (second == null) return null;
  return first + second;
}

List<Card> checkFlush(List<Card> cards) {
  cards.sort(_suitFirstComparison);

  if (cards.length < 5) return null;
  Ordinal ordinal;
  List<Card> rValue = [];
  for (Card card in cards) {
    if (card.ordinal != ordinal) {
      rValue = [card];
    } else {
      rValue.add(card);
      if (rValue.length == 5) {
        return rValue;
      }
    }
  }
  return null;
}

List<Card> checkFourOfKind(List<Card> cards) {
  return checkNOfKind(cards, 4);
}

List<Card> checkThreeOfKind(List<Card> cards) {
  return checkNOfKind(cards, 3);
}

List<Card> checkTwoOfKind(List<Card> cards) {
  return checkNOfKind(cards, 2);
}

List<Card> checkNOfKind(List<Card> cards, int n) {
  cards.sort(_ordinalFirstComparison);

  Ordinal expected;
  List<Card> rValue = [];
  for (final card in cards) {
    if (card.ordinal == expected) {
      rValue.add(card);
      if (rValue.length == n) return rValue;
    } else {
      expected = card.ordinal;
      rValue = [card];
    }
  }
  return null;
}

List<Card> checkHighCard(List<Card> cards) {
  cards.sort(_suitFirstComparison);
  if (cards.length == 0) return null;
  return [cards.first];
}
