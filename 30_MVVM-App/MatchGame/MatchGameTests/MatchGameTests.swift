//
//  MatchGameTests.swift
//  MatchGameTests
//
//  Created by Dr. Wolfram Schroers on 11/6/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import XCTest
@testable import MatchGame

/// These are data model only tests.
class MatchGameTests: XCTestCase {

    var matchModel = MatchModel()

    // MARK: Data model only

    /// Verify game lost condition.
    func testGameNotLost() {
        matchModel.initialCount = 20
        matchModel.restart()
        XCTAssertFalse(matchModel.isGameOver())
    }

    /// Verify dumb engine.
    func testDumbEngine() {
        matchModel.initialCount = 10
        matchModel.strategy = .dumb
        matchModel.restart()
        matchModel.performUserMove(1)

        XCTAssertEqual(matchModel.performComputerMove(), 1)
        XCTAssertEqual(matchModel.matchCount, 8)
    }

    /// Verify smart engine.
    func testSmartEngine() {
        matchModel.initialCount = 12
        matchModel.strategy = .smart
        matchModel.restart()
        matchModel.performUserMove(1)

        XCTAssertEqual(matchModel.performComputerMove(), 2)
        XCTAssertEqual(matchModel.matchCount, 9)
    }

    // MARK: View model

    /// Test the workflow of a game.
    func testFullGame() {
        let mainVM = MainViewModel()
        let callbackMock = MainTakeActionMock()
        mainVM.delegate = callbackMock

        // Verify the initial state.
        XCTAssertFalse(callbackMock.statesUpdateCalled)
        XCTAssertNil(callbackMock.matchesNumber)
        XCTAssertNil(callbackMock.matchesRemoved)
        XCTAssertFalse(callbackMock.dialogPresented)

        // Simulate the game start when the app launches.
        mainVM.viewWillAppear()
        XCTAssertTrue(callbackMock.statesUpdateCalled)
        XCTAssertNotNil(callbackMock.matchesNumber)
        XCTAssertNil(callbackMock.matchesRemoved)
        XCTAssertFalse(callbackMock.dialogPresented)
        XCTAssertEqual(callbackMock.matchesNumber, 18)

        // Play a single round.
        callbackMock.resetFlags()
        mainVM.userTappedTake(3)
        XCTAssertTrue(callbackMock.statesUpdateCalled)
        XCTAssertNil(callbackMock.matchesNumber)
        XCTAssertNotNil(callbackMock.matchesRemoved)
        XCTAssertFalse(callbackMock.dialogPresented)
        XCTAssertEqual(callbackMock.matchesRemoved, 1)

        // Play the game until the end.
        mainVM.userTappedTake(3)
        XCTAssertFalse(callbackMock.dialogPresented)
        mainVM.userTappedTake(3)
        XCTAssertFalse(callbackMock.dialogPresented)
        mainVM.userTappedTake(3)
        XCTAssertFalse(callbackMock.dialogPresented)
        mainVM.userTappedTake(1)
        XCTAssertTrue(callbackMock.dialogPresented)
    }

    /// Test that the "Take 3" is properly disabled when `removeMax` == 2.
    func testTakeThreeIsDisabled() {
        let mainVM = MainViewModel()

        // Assert that initially both buttons are enabled.
        XCTAssertTrue(mainVM.buttonTwoEnabled)
        XCTAssertTrue(mainVM.buttonThreeEnabled)

        // Change removeMax.
        var context = MatchDataContext()
        context.removeMax = 2
        mainVM.dataContextChanged(context)

        // Assert that now only the "Take 2" is enabled.
        XCTAssertTrue(mainVM.buttonTwoEnabled)
        XCTAssertFalse(mainVM.buttonThreeEnabled)
    }

}
