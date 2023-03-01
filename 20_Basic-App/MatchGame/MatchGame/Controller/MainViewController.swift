//
//  ViewController.swift
//  MatchGame
//
//  Created by Dr. Wolfram Schroers on 5/26/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import UIKit

/// Accept changes to the data model settings.
protocol CanAcceptSettings: AnyObject {

    /// Accept the current settings.
    func settingsChanged(_ strategySelector: Int,
                         initialMatchCount: Int,
                         removeMax: Int)
}

/// The view controller of the first screen responsible for the game.
class MainViewController: UIViewController, CanAcceptSettings {

    // MARK: Lifecycle/workflow management

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Start a new game.
        startNewGame()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settings" {
            guard let controller = segue.destination as? SettingsViewController else {
                return
            }

            // Set the initial state of the settings screen.
            controller.initialMatchCount = matchModel.initialCount
            controller.removeMax = matchModel.removeMax
            switch matchModel.strategy {
            case .dumb:
                controller.strategy = 0
            case .wild:
                controller.strategy = 1
            case .smart:
                controller.strategy = 2
            }
            controller.delegate = self
        }
    }

    // MARK: CanAcceptSettings

    func settingsChanged(_ strategySelector: Int,
                         initialMatchCount: Int,
                         removeMax: Int) {
        matchModel.initialCount = initialMatchCount
        switch strategySelector {
        case 0:
            matchModel.strategy = .dumb
        case 1:
            matchModel.strategy = .wild
        default:
            matchModel.strategy = .smart
        }
        matchModel.removeMax = removeMax
        updateButtons()
    }

    // MARK: Data Model

    /// Data model for the game state.
    var matchModel = MatchModel()

    // MARK: User Interface

    /// The label at the top displaying the current game state.
    @IBOutlet weak var gameStateLabel: UILabel!

    /// The move report label beneath the game state label.
    @IBOutlet weak var moveReportLabel: UILabel!

    /// The graphical match pile.
    @IBOutlet weak var matchPileView: MatchPileView!

    /// The "Take 2" button. It can be disabled if needed.
    @IBOutlet weak var takeTwoButton: UIButton!

    /// The "Take 3" button. It can be disabled if needed.
    @IBOutlet weak var takeThreeButton: UIButton!

    /// Response to user tapping "Take 1".
    @IBAction func userTappedTakeOne(_ sender: AnyObject) {
        userMove(1)
    }

    /// Response to user tapping "Take 2".
    @IBAction func userTappedTakeTwo(_ sender: AnyObject) {
        userMove(2)
    }

    /// Response to user tapping "Take 3".
    @IBAction func userTappedTakeThree(_ sender: AnyObject) {
        userMove(3)
    }

    // MARK: Game flow/controller

    /// - returns: A number of matches with proper unit.
    func prettyMatchString(_ count: Int) -> String {
        switch count {
        case 1:
            return NSLocalizedString("1 match", comment: "")
        default:
            return String(format: NSLocalizedString("%d matches", comment: ""), count)
        }
    }

    /// Start a new game.
    func startNewGame() {
        // Update the data model.
        matchModel.restart()

        // Configure the view.
        moveReportLabel.text = NSLocalizedString("Please start", comment: "")
        updateGameStateLabel()
        updateButtons()
        matchPileView.setMatches(matchModel.matchCount)
    }

    /// Update the game state label.
    func updateGameStateLabel() {
        gameStateLabel.text = prettyMatchString(matchModel.matchCount)
    }

    /// Adjust the buttons -- disable "Take 2" and/or "Take 3" when needed.
    func updateButtons() {
        switch min(matchModel.matchCount, matchModel.removeMax) {
        case 2:
            takeTwoButton.isEnabled = true
            takeThreeButton.isEnabled = false
        case 1:
            takeTwoButton.isEnabled = false
            takeThreeButton.isEnabled = false
        default:
            takeTwoButton.isEnabled = true
            takeThreeButton.isEnabled = true
        }
    }

    /// End a single game.
    func gameOver(_ message: String) {
        let messageController = UIAlertController(title: NSLocalizedString("The game is over", comment: ""),
                                                  message: message,
                                                  preferredStyle: .alert)
        let buttonResponse = UIAlertAction(title: NSLocalizedString("New game", comment: ""),
                                           style: .default) { (_) in
                                            self.startNewGame()
        }
        messageController.addAction(buttonResponse)

        present(messageController, animated: true, completion: nil)
    }

    /// Execute a user move.
    func userMove(_ count: Int) {
        // Update the data model.
        matchModel.performUserMove(count)

        // Update the UI.
        matchPileView.removeMatches(count)

        // Check if the user lost.
        if matchModel.isGameOver() {
            // The user has lost.
            gameOver(NSLocalizedString("You have lost", comment: ""))
        } else {
            // The computer moves.
            let computerMove = matchModel.performComputerMove()

            // Update the UI.
            matchPileView.removeMatches(computerMove)

            // Check if the computer lost.
            if matchModel.isGameOver() {
                // The computer lost.
                gameOver(NSLocalizedString("I have lost", comment: ""))
            } else {
                // Update the UI again (print the computer move).
                moveReportLabel.text = String(format: NSLocalizedString("I remove %@", comment: ""),
                        prettyMatchString(computerMove))
            }
        }

        // Update the UI once more.
        updateGameStateLabel()
        updateButtons()
    }
}
