//
//  SettingsViewController.swift
//  MatchGame
//
//  Created by Dr. Wolfram Schroers on 5/27/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import UIKit

/// View controller of the second screen responsible for the settings.
class SettingsViewController: UIViewController {

    // MARK: Settings received from the primary game view controller.

    /// Initial number of matches.
    var initialMatchCount = 18

    /// Initial removal maximum.
    var removeMax = 3

    /// Initial strategy selector value.
    var strategy = 0

    /// Delegate for reporting changes.
    weak var delegate: CanAcceptSettings?

    // MARK: Lifecycle/workflow management

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure the initial state with current settings.
        initialMatchCountSlider.value = Float(initialMatchCount)
        removeMaxSlider.value = Float(removeMax)
        strategySelector.selectedSegmentIndex = strategy

        updateLabels()
    }

    // MARK: User Interface

    /// Update the labels on this screen.
    func updateLabels() {
        initialMatchCountLabel.text = NSLocalizedString("Initial number of matches: \(initialMatchCount)", comment: "")
        removeMaxLabel.text = NSLocalizedString("Maximum number to remove: \(removeMax)", comment: "")
    }

    /// User taps the "Done" button.
    @IBAction func userTapsDone(_ sender: AnyObject) {
        // Submit the current settings to the delegate.
        delegate?.settingsChanged(strategySelector.selectedSegmentIndex,
            initialMatchCount: initialMatchCount,
            removeMax: removeMax)

        // Transition back to primary game screen.
        dismiss(animated: true, completion: nil)
    }

    /// Label for initial match count.
    @IBOutlet weak var initialMatchCountLabel: UILabel!

    /// Slider for initial match count.
    @IBOutlet weak var initialMatchCountSlider: UISlider!

    /// Label for remove maximum count.
    @IBOutlet weak var removeMaxLabel: UILabel!

    /// Slider for remove maximum count.
    @IBOutlet weak var removeMaxSlider: UISlider!

    /// Segmented control for strategy selection.
    @IBOutlet weak var strategySelector: UISegmentedControl!

    /// Reaction to moving the initial count slider.
    @IBAction func userChangesInitialMatchCount(_ sender: AnyObject) {
        initialMatchCount = Int(initialMatchCountSlider.value)
        updateLabels()
    }

    /// Reaction to moving the remove maximum slider.
    @IBAction func userChangesRemoveMaxCount(_ sender: AnyObject) {
        removeMax = Int(removeMaxSlider.value)
        updateLabels()
    }
}
