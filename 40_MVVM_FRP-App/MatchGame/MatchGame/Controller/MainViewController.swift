//
//  ViewController.swift
//  MatchGame
//
//  Created by Dr. Wolfram Schroers on 5/26/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import MatchView

/// The view controller of the first screen responsible for the game.
class MainViewController: MVVMViewController {

    // MARK: The corresponding view model (view first)

    /// The main screen view model.
    var viewModel = MainViewModel()

    // MARK: Lifecycle/workflow management

    override func viewDidLoad() {
        super.viewDidLoad()

        // Data bindings: wire up the label texts.
        gameStateLabel.rac_text <~ viewModel.gameState
        moveReportLabel.rac_text <~ viewModel.moveReport

        // Wire up the buttons to the view model actions.
        takeOneButton.addTarget(viewModel.takeOneAction, action: CocoaAction<Any>.selector, for: .touchUpInside)
        takeTwoButton.addTarget(viewModel.takeTwoAction, action: CocoaAction<Any>.selector, for: .touchUpInside)
        takeThreeButton.addTarget(viewModel.takeThreeAction, action: CocoaAction<Any>.selector, for: .touchUpInside)
        infoButton.addTarget(viewModel.infoButtonAction, action: CocoaAction<Any>.selector, for: .touchUpInside)

        // Wire up the button "enabled" states.
        takeTwoButton.rac_enabled <~ viewModel.buttonTwoEnabled
        takeThreeButton.rac_enabled <~ viewModel.buttonThreeEnabled

        // Wire up the match view activities (reset and remove matches with animation).
        viewModel.resetMatchView.producer.startWithValues { (count) in
            self.matchPileView.setMatches(count)
        }
        viewModel.removeFromMatchView.producer.skip(first: 1).startWithValues { (count) in
            self.matchPileView.removeMatches(count)
        }

        // Handle screen transitions when requested.
        let transitionSubscriber = Signal<Void, Never>.Observer(value: { self.transitionToSettings() })
        viewModel.transitionSignal.observe(transitionSubscriber)

        // Handle dialogs.
        commonBindings(viewModel)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Direct method call when view appears.
        viewModel.viewWillAppear()
    }

    // MARK: User Interface

    /// The label at the top displaying the current game state.
    @IBOutlet weak var gameStateLabel: UILabel!

    /// The move report label beneath the game state label.
    @IBOutlet weak var moveReportLabel: UILabel!

    /// The graphical match pile.
    @IBOutlet weak var matchPileView: MatchPileView!

    /// The "Take 1" button.
    @IBOutlet weak var takeOneButton: UIButton!

    /// The "Take 2" button.
    @IBOutlet weak var takeTwoButton: UIButton!

    /// The "Take 3" button.
    @IBOutlet weak var takeThreeButton: UIButton!

    /// The "Info" button.
    @IBOutlet weak var infoButton: UIButton!

    // MARK: Private

    fileprivate func transitionToSettings() {
        // Instantiate the settings screen view controller and configure the UI transition.
        guard let settingsController = UIStoryboard(name: "Main",
                                                    bundle: nil)
                .instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController else {
            return
        }
        settingsController.modalPresentationStyle = .currentContext
        settingsController.modalTransitionStyle = .flipHorizontal

        // Establish VM<->VM bindings.
        viewModel.configure(settingsController.viewModel)

        // Perform the transition.
        present(settingsController, animated: true, completion: nil)
    }
}
