//
//  SettingsViewController.swift
//  MatchGame
//
//  Created by Dr. Wolfram Schroers on 5/27/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import UIKit

/// View controller of the second screen responsible for the settings.
class SettingsViewController: MVVMViewController, SettingsTakeAction {

    // MARK: The corresponding view model (view first)

    /// The main screen view model.
    var viewModel: SettingsViewModel

    // MARK: Lifecycle/workflow management

    required init?(coder aDecoder: NSCoder) {
        viewModel = SettingsViewModel()
        super.init(coder: aDecoder)
        viewModel.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }

    /// Called by the main game screen view controller to configure this controller.
    ///
    /// This controller uses the information to configure the view model.
    func configure(_ context: MatchDataContext,
                   contextDelegate: ReceiveDataContext) {
        viewModel.configure(context, contextDelegate: contextDelegate)
    }

    // MARK: User Interface

    /// User taps the "Done" button.
    @IBAction func userTapsDone(_ sender: AnyObject) {
        viewModel.userTapsDone()
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
        viewModel.userMovesInitialMatchCountSlider(initialMatchCountSlider.value)
    }

    /// Reaction to moving the remove maximum slider.
    @IBAction func userChangesRemoveMaxCount(_ sender: AnyObject) {
        viewModel.userMovesRemoveMaxSlider(removeMaxSlider.value)
    }

    /// Reaction to picking a selection on the segmented control.
    @IBAction func userSelectsSegmentedControl(_ sender: AnyObject) {
        viewModel.userSelectsStrategy(strategySelector.selectedSegmentIndex)
    }

    // MARK: SettingsTakeAction

    /// Trigger the screen transition back the main screen (handled by the primary game view controller).
    func returnToMain() {
        dismiss(animated: true, completion: nil)
    }

    /// Update the UI elements.
    func updateLabelsAndSlidersAndSegControl() {
        initialMatchCountLabel.text = viewModel.initialMatchSetting
        removeMaxLabel.text = viewModel.removeMaxSetting
        initialMatchCountSlider.value = viewModel.initialMatchSliderValue
        removeMaxSlider.value = viewModel.removeMaxSliderValue
        strategySelector.selectedSegmentIndex = viewModel.strategyIndex
    }
}
