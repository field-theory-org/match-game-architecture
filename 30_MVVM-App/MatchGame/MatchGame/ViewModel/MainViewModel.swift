//
//  MainViewModel.swift
//  MatchGame
//
//  Created by Dr. Wolfram Schroers on 5/27/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import UIKit

/// The view model let's the controller know that something must be done.
protocol MainTakeAction: CanPresentDialog {

    /// Transition to "Settings" screen.
    func transitionToSettings()

    /// Update the labels and button enabled states.
    func updateLabelsAndButtonStates()

    /// Set a certain number of matches in the match pile view.
    func setMatchesInPileView(_ count: Int)

    /// Remove a certain number of matches in the match pile view.
    func removeMatchesInPileView(_ count: Int)
}

/// View model corresponding to the "Main" game screen.
class MainViewModel: NSObject, ReceiveDataContext {

    // MARK: The data model (a new home!)

    /// Data model for the game state.
    fileprivate var matchModel = MatchModel()

    // MARK: State of the view

    /// The text shown as game state.
    var gameState: String {
        prettyMatchString(matchModel.matchCount)
    }

    /// The text shown as move report.
    var moveReport = ""

    /// The enabled state of the "Take 2" button.
    var buttonTwoEnabled: Bool {
        matchModel.userLimit() > 1
    }

    /// The enabled state of the "Take 3" button.
    var buttonThreeEnabled: Bool {
        matchModel.userLimit() > 2
    }

    // MARK: VM talks to Controller

    /// Activities are triggered through the delegate.
    weak var delegate: MainTakeAction?

    // MARK: Controller talks to VM

    /// Return an appropriate `MatchDataContext`.
    func createContext() -> MatchDataContext {
        var context = MatchDataContext()
        context.initialMatchCount = matchModel.initialCount
        context.removeMax = matchModel.removeMax
        switch matchModel.strategy {
        case .dumb:
            context.strategyIndex = 0
        case .wild:
            context.strategyIndex = 1
        case .smart:
            context.strategyIndex = 2
        }
        return context
    }

    /// Handle when the view will appear.
    func viewWillAppear() {
        startNewGame()
    }

    /// Respond to "Info" button.
    func userTappedInfo() {
        delegate?.transitionToSettings()
    }

    /// Respond to "Take 1", "Take 2" and "Take 3" button.
    func userTappedTake(_ count: Int) {
        userMove(count)
    }

    // MARK: VM talks to another VM -- CanAcceptSettings

    func dataContextChanged(_ context: MatchDataContext) {
        matchModel.initialCount = context.initialMatchCount
        matchModel.removeMax = context.removeMax
        switch context.strategyIndex {
        case 0:
            matchModel.strategy = .dumb
        case 1:
            matchModel.strategy = .wild
        default:
            matchModel.strategy = .smart
        }
    }

    // MARK: Internal helpers

    /// Return a number of matches with proper unit.
    fileprivate func prettyMatchString(_ count: Int) -> String {
        switch count {
        case 1:
            return NSLocalizedString("1 match", comment: "")
        default:
            return String(format: NSLocalizedString("%d matches", comment: ""), count)
        }
    }

    /// Start a new game.
    fileprivate func startNewGame() {
        // Handle the data model.
        matchModel.restart()

        // Handle the state of the view that shall be shown.
        moveReport = NSLocalizedString("Please start", comment: "")

        // Let the controller update the state.
        delegate?.setMatchesInPileView(matchModel.matchCount)
        delegate?.updateLabelsAndButtonStates()
    }

    /// End a single game.
    fileprivate func gameOver(_ message: String) {
        delegate?.presentDialog(NSLocalizedString("The game is over", comment: ""),
                                message: message,
                                okButtonText: NSLocalizedString("New game", comment: ""),
                                action: {
                                    self.startNewGame()
                                },
                                hasCancel: false)
    }

    /// Execute a user move.
    fileprivate func userMove(_ count: Int) {
        // Update the data model.
        matchModel.performUserMove(count)

        // Update the match pile UI.
        delegate?.removeMatchesInPileView(count)

        // Check if the user lost.
        if matchModel.isGameOver() {
            // The user has lost.
            gameOver(NSLocalizedString("You have lost", comment: ""))
        } else {
            // The computer moves.
            let computerMove = matchModel.performComputerMove()

            // Update the match pile UI again.
            delegate?.removeMatchesInPileView(computerMove)

            // Check if the computer lost.
            if matchModel.isGameOver() {
                // The computer lost.
                gameOver(NSLocalizedString("I have lost", comment: ""))
            } else {
                // Update the UI again (print the computer move).
                moveReport = String(format: NSLocalizedString("I remove %@", comment: ""),
                                    prettyMatchString(computerMove))
            }
        }

        // Let the controller update the state.
        delegate?.updateLabelsAndButtonStates()
    }
}
