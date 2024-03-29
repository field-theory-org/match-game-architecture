//
//  SettingsViewController.swift
//  MatchGame
//
//  Created by Dr. Wolfram Schroers on 5/27/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

/// View controller of the second screen responsible for the settings.
class SettingsViewController: MVVMViewController {

    // MARK: The corresponding view model (view first)

    /// The main screen view model.
    var viewModel = SettingsViewModel()

    // MARK: Lifecycle/workflow management

    override func viewDidLoad() {
        super.viewDidLoad()

        // Data binding: wire up the label texts, slider values and segmented control setting.
        initialMatchCountLabel.rac_text <~ viewModel.initialMatchSetting
        viewModel.initialMatchSliderValue <~ initialMatchCountSlider.reactive.values

        removeMaxLabel.rac_text <~ viewModel.removeMaxSetting
        viewModel.removeMaxSliderValue <~ removeMaxSlider.reactive.values

        strategySelector.rac_selectedSegmentIndex <~ viewModel.strategyIndex
        viewModel.strategyIndex <~ strategySelector.reactive.selectedSegmentIndexes

        // Set up the action for the "Done" button.
        doneButton.addTarget(viewModel.doneAction, action: CocoaAction<Any>.selector, for: .touchUpInside)

        // Set up response for dismissing the settings screen.
        let doneSubscriber = Signal<Void, Never>.Observer(value: { self.dismiss(animated: true, completion: nil) })
        viewModel.doneSignal.observe(doneSubscriber)

        // Handle dialogs.
        commonBindings(viewModel as? PresentDialog)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Set up initial values when the view appears (this is a little "old-style").
        initialMatchCountSlider.value = viewModel.initialMatchSliderValue.value
        removeMaxSlider.value = viewModel.removeMaxSliderValue.value
        strategySelector.selectedSegmentIndex = viewModel.strategyIndex.value
    }

    // MARK: User Interface

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

    /// The "Done" button.
    @IBOutlet weak var doneButton: UIButton!
}
