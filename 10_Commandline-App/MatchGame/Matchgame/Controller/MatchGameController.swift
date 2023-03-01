//
//  MatchGameController.swift
//  Matchgame
//
//  Created by Dr. Wolfram Schroers on 5/9/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import Foundation

/// Controller for the game workflow.
class MatchGameController {

    /// The data model instance.
    var model = MatchModel()

    /// Default configuration values.
    let defaultInitialCount = 18
    let defaultRemoveMax = 3
    let defaultStrategy = MatchModel.Strategy.wild

    /// Main app workflow.
    func play() {

        // Display the welcome message at game launch.
        MatchGameUI.welcome()

        // Configure the starting parameters.
        let configuration = MatchGameUI.queryConfiguration()
        model.initialCount = (configuration.0 > 0) ? configuration.0 : defaultInitialCount
        model.removeMax = ((configuration.1 > 0 && configuration.1 < configuration.0) ?
                           configuration.1 : defaultRemoveMax)
        switch configuration.2 {
        case 1:
            model.strategy = MatchModel.Strategy.dumb
        case 2:
            model.strategy = MatchModel.Strategy.wild
        case 3:
            model.strategy = MatchModel.Strategy.smart
        default:
            model.strategy = defaultStrategy
        }
        model.restart()

        // Main loop.
        while true {
            MatchGameUI.showState(model.matchCount)

            // Query for and perform a valid user move.
            let userLimit = model.userLimit()
            let userMove = MatchGameUI.userMove(userLimit)
            model.performUserMove(userMove)

            if model.isGameOver() {
                print("I'm sorry, you lost")
                break
            }

            // Perform the computer move.
            let macMove = model.performComputerMove()
            MatchGameUI.showComputerMove(macMove)

            if model.isGameOver() {
                print("Congratulations, you won")
                break
            }
        }

        // Display the final message.
        MatchGameUI.byeBye()
    }
}
