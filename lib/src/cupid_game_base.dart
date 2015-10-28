// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library cupid_game.base;

/// Name of a thing. Ready of internationalization and natural language
/// generation.
class Name {
  final String name;
  final Pronoun pronoun;
}

class Character extends Object with Name {
  final Set<Trait> traits;
  final Set<Memory> memories;
  final Set<Token> tokens;
  final Map<Character, Relationship> relations;

  Scale richHomeless;
  Scale beautifulUgly;
  // TODO add more stats (can be the ones below)
  // Scale religiousAtheist;
  // Scale modestVain;
  // Scale extrovertedIntroverted;

  /// Applies all the transformations from [traits] and [memories].
  ///
  /// The state of the Character as described in this class is as if
  /// "in a vacuum". But different memories and traits and relations
  /// can have a (non-lasting) effect on the character.
  ///
  /// Whether this creates a copy of the Character or whether this is a lens
  /// is an implementation detail.
  Character applyAll();
}

/// Describes a relationship between one character and another. It is one-way
/// (Bob can like Alice and Alice can hate Bob).
///
/// At first, we can keep it simple with [loveHate] but we might want to extend
/// it for more interesting relationships. For example, Bob can dislike Alice
/// but respect her. Alice can like Bob but fear him. And so on.
///
/// Use:
///
///     bob.relations[alice].increaseLove(1);
class Relationship {
  final Scale loveHate;
  // ... add respect?
}

/// A "natural" scale. Goes from -1 to 1 and the closer we are to the extremes
/// the harder it is to change in that way.
///
/// Scale instances should be always named by both extremes. "loveHate" makes
/// it clear that 1 == absolute romantic love and -1 == absolute hate and
/// so 0 is probably indifference. If it was named just "love", we wouldn't be
/// sure what the other extreme is.
///
/// Scale automatically limits the value to the range of <-1;1>.
///
/// Examples:
///
/// - loveHate
/// - richHomeless
/// - ...
class Scale {
  final float value;

  Scale changeBy(float v);
}

/// Traits are a [Character]'s distinguishing qualities and characteristics that
/// they either have or don't have. (Everything else is a [Scale].)
///
/// Examples of traits are: LovesCats, LovesMusic,
class Trait {
  final String description;
  // ...
}

/// Tokens are material things (even living things) that are in the world.
///
/// Examples: a gun, a puppy, a house, a baby
///
/// Tokens are materialized by Actions ("Alice finds a gun in the cellar")
/// and they can be prerequisites to other Actions ("Alice shoots Bob").
class Token extends Object with Name {

}

/// Memories are parts of the history of the game world. They are created
/// by [Action] events. Actions are also responsible for adding them to each
/// [Character] who should have the memory.
///
/// Memories transform people in different ways through [transform]. They are
/// a non-permanent modification of a Character's state.
///
/// Memories can be forgotten by a Character (removed from his
/// [Character.memories]) and they can also be shared among Characters.
///
/// Ex.: Bob and Alice spend a great weekend together. They each gain a shared
/// [Memory] ("weekend"). The memory transforms each of them -- it makes them
/// like each other more. When Alice shares the memory of the weekend with
/// her friend Diana, she is also transformed by liking Bob a little bit more.
/// Sometime along the way, someone may want Alice to forget (lose) the memory
/// or she might forget it herself.
class Memory {
  final int timestamp;
  Character transform(Character ch);
}


// -- Planning --

/// The game state.
class World {
  int timestamp;
  final Set<Character> characters;
  /// Tokens that are not directly owned by any of the [characters].
  final Set<Token> tokens;

  /// Creates an exact and deep copy of this World state. For planning, we need
  /// to have an arbitrary amount of (possible) states so we can choose paths.
  World clone();
}

/// A description of a desirable world. This is the goal of plans.
///
/// This is different from [World] by having everything optional.
///
/// For example, a GoalWorldState for Bob might be that he is married to
/// Alice. He doesn't care about the other facts about that desired World so
/// the planning algorithm can ignore them. If Bob's GoalWorldState was more
/// defined (not only is Bob married to Alice, but also as is rich as today)
/// then the planning algorithm needs to take that into account.
class GoalWorldState {

}

/// Actions take a world state and transform it into another.
class Action {
  /// A function (or class instance?) that takes the current state (World, two
  /// characters, three characters, ... see the extending classes below) and
  /// returns whether or not this action is applicable.
  final antecedent;
  /// A function (or class instance?) that takes the current World state and
  /// returns the transformed state.
  final consequent;
}

class TwoCharactersAction extends Action {
  final Character primary;
  final Character secondary;
  TwoCharactersAction(this.primary, this.secondary);
}
class ThreeCharactersAction extends Action {}
class WorldAction extends Action {}



enum Pronoun { I, YOU, HE, SHE, IT, THEY }
enum Sex { MALE, FEMALE }
enum SexualOrientation { HETEROSEXUAL, HOMOSEXUAL, BISEXUAL }
