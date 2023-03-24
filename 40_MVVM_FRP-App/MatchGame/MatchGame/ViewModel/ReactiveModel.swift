//
//  ModelWrapper.swift
//  MatchGame
//
//  Created by Dr. Wolfram Schroers on 5/30/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import Foundation
import ReactiveSwift
import ReactiveCocoa
import MatchModel

/// This class exports the API of the data model to ReactiveCocoa-style mutable properties.
///
/// - Note: This wrapper looks quite "old style". This may be improved/simplified with advanced use of the
/// ReactiveCocoa-API. Alternatively, the data model could be rewritten from scratch with FRP in mind.
class ReactiveModel {

    // MARK: Public API

    /// The current move engine being used.
    var strategy = MutableProperty(MatchModel.Strategy.dumb)

    /// The current match count.
    var matchCount = MutableProperty(18)

    /// The initial number of matches.
    var initialCount = MutableProperty(18)

    /// The maximum number of matches to remove.
    var removeMax = MutableProperty(3)

    /// The maximum number of matches the user can remove.
    var userLimit = MutableProperty(3)

    /// Indicate whether the game is over or not.
    var isGameOver = MutableProperty(false)

    /// Designated initializer.
    init() {
        classicMatchModel = MatchModel()
        updateProperties()

        strategy.producer.startWithValues { (newStrategy) in
            self.classicMatchModel.strategy = newStrategy
        }
        initialCount.producer.startWithValues { (newInitialCount) in
            self.classicMatchModel.initialCount = newInitialCount
        }
        removeMax.producer.startWithValues { (newRemoveMax) in
            self.classicMatchModel.removeMax = newRemoveMax
            self.userLimit.value = self.classicMatchModel.userLimit()
        }
    }

    func restart() {
        classicMatchModel.restart()
        updateProperties()
    }

    func performComputerMove() -> Int {
        let computerMove = classicMatchModel.performComputerMove()
        updateProperties()
        return computerMove
    }

    func performUserMove(_ move: Int) {
        classicMatchModel.performUserMove(move)
        updateProperties()
    }

    // MARK: Private

    /// The data model with the "old" API.
    fileprivate var classicMatchModel: MatchModel

    /// Update the properties.
    ///
    /// This could be refactored with KVO, but it will neither make the code easier to read nor to understand.
    fileprivate func updateProperties() {
        strategy.value     = classicMatchModel.strategy
        matchCount.value   = classicMatchModel.matchCount
        initialCount.value = classicMatchModel.initialCount
        removeMax.value    = classicMatchModel.removeMax
        userLimit.value    = classicMatchModel.userLimit()
        isGameOver.value   = classicMatchModel.isGameOver()
    }
}
