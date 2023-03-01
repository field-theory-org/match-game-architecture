//
//  MainTakeActionMock.swift
//  MatchGameTests
//
//  Created by Dr. Wolfram Schroers on 5/26/16.
//  Copyright © 2022 Wolfram Schroers. All rights reserved.
//

import Foundation

/// Mock class implementing the `MainTakeAction` protocol in tests.
class MainTakeActionMock: MainTakeAction {

    // MARK: Mock-specific handling

    // Flags for which methods have been invoked.
    var statesUpdateCalled = false
    var matchesNumber: Int?
    var matchesRemoved: Int?
    var dialogPresented = false

    /// Reset the flags.
    func resetFlags() {
        statesUpdateCalled = false
        matchesNumber = nil
        matchesRemoved = nil
        dialogPresented = false
    }

    // MARK: MainTakeAction implementation

    func transitionToSettings() {
        // Not used.
    }

    func updateLabelsAndButtonStates() {
        statesUpdateCalled = true
    }

    func setMatchesInPileView(_ count: Int) {
        matchesNumber = count
    }

    func removeMatchesInPileView(_ count: Int) {
        matchesRemoved = count
    }

    func presentDialog(_ title: String,
                       message: String,
                       okButtonText: String,
                       action: @escaping () -> Void,
                       hasCancel: Bool) {
        dialogPresented = true
    }

}
