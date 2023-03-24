//
//  MatchModelTests.swift
//  MatchModel
//
//  Created by Dr. Wolfram Schroers on 3/10/23.
//  Copyright © 2023 Wolfram Schroers. All rights reserved.
//

import XCTest
@testable import MatchModel

final class MatchModelTests: XCTestCase {

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
}
