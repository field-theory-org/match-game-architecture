//
//  MatchModel.swift
//  Matchgame
//
//  Created by Dr. Wolfram Schroers on 5/9/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import Foundation

/// The compound data model of the match game.
class MatchModel {

    // MARK: Data types

    /// Enumeration for the three types of supported move engines.
    ///
    /// - Dumb: Always takes a single match.
    /// - Wild: Takes a random number of matches.
    /// - Smart: Perfect play, takes the optimal number of matches.
    enum Strategy {
        case dumb
        case wild
        case smart
    }

    // MARK: Administrative

    /// Standard initializer.
    init() {
        engine = DumbEngine(myPile: pile)
    }

    // MARK: Game state

    /// Choose an engine based on the selected strategy.
    var strategyType = Strategy.dumb {
        willSet(newStrategy) {
            switch newStrategy {
            case .dumb:
                engine = DumbEngine(myPile: pile)
            case .wild:
                engine = WildEngine(myPile: pile)
            case .smart:
                engine = SmartEngine(myPile: pile)
            }
        }
    }

    /// The currently active strategy.
    var strategy: Strategy {
        get {
            strategyType
        }
        set(newStrategy) {
            strategyType = newStrategy
        }
    }

    /// The current number of matches.
    var matchCount: Int {
        pile.count
    }

    /// The initial count of matches when restarting a game. Must always be larger than `removeMax`.
    var initialCount: Int {
        get {
            pile.initialCount
        }
        set(newInitialCount) {
            assert(newInitialCount > 0,
                   "The initial number of matches must be greater than 0")
            assert(newInitialCount > pile.removeMax,
                   "The initial number of matches must be greater than the removal maximum")

            pile.initialCount = newInitialCount
        }
    }

    /// The maximum number of matches that can be removed each move.
    /// Must always be larger than 0 and smaller than `initialCount`.
    var removeMax: Int {
        get {
            pile.removeMax
        }
        set(newRemoveMax) {
            assert(newRemoveMax > 0,
                   "The maximum removal number must be greater than 0")
            assert(newRemoveMax < pile.initialCount,
                   "The initial number of matches must be greater than the removal maximum")

            pile.removeMax = newRemoveMax
        }
    }

    /// - returns: The current limit of matches the user can take in his move. Returns 0 on the computer's move.
    func userLimit() -> Int {
        (pile.rightToMove == .user) ? pile.limit() : 0
    }

    /// - returns: Whether the game is lost.
    func isGameOver() -> Bool {
        pile.isLost()
    }

    // MARK: Public methods to manipulate the game state

    /// Restart the game.
    func restart() {
        pile.rightToMove = .user
        pile.restart()
    }

    /// Compute and perform the computer move.
    ///
    /// - returns: The computer's move.
    func performComputerMove() -> Int {
        assert(pile.rightToMove == .computer,
               "This method must only be called when it's the computer's turn to move")

        let move = engine.computerMove()
        pile.removeMatches(move)
        pile.rightToMove = .user
        return move
    }

    /// Perform the user move.
    ///
    /// - Parameter move: The number of matches the user removes.
    func performUserMove(_ move: Int) {
        assert(move <= pile.limit(),
               "The user move is invalid and must be validated prior to calling this method")
        assert(pile.rightToMove == .user,
               "This method must only be called when it's the user's turn to move")

        pile.removeMatches(move)
        pile.rightToMove = .computer
    }

    // MARK: Private implementation

    /// The match pile (playing board state).
    fileprivate var pile = MatchPile()

    /// Search engine for the computer move.
    fileprivate var engine: EngineMove
}
