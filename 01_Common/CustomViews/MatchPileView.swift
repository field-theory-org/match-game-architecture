//
//  MatchPileView.swift
//  MatchGame
//
//  Created by Dr. Wolfram Schroers on 5/17/16.
//  Copyright © 2016 Wolfram Schroers. All rights reserved.
//

import UIKit

/// The match pile on the screen.
class MatchPileView: UIView {

    /// Number of currently visible matches.
    fileprivate var visibleMatches: Int = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    /// Configure this view (sets background color).
    fileprivate func setup() {
        backgroundColor = UIColor.clear
    }

    /// Set a fixed number of matches. Abort animations if needed.
    func setMatches(_ matchNumber: Int) {
        // Remove all currently visible/animating matches.
        let oldMatches = subviews
        for match in oldMatches {
            match.removeFromSuperview()
        }

        let matchesPerRow = 10
        let rows = matchNumber / matchesPerRow
        let matchesInLastRow = matchNumber - (rows * matchesPerRow)

        // Draw all rows up to the last one.
        for row in 0..<rows {
            for column in 0..<matchesPerRow {
                let position = CGRect(x: CGFloat(10 + column * 30),
                                      y: CGFloat(0 + row * 80),
                                      width: 30,
                                      height: 80)
                let match = SingleMatchView(frame: position)
                addSubview(match)
            }
        }

        // Draw the final row.
        for column in 0..<matchesInLastRow {
            let position = CGRect(x: CGFloat(10 + column * 30),
                                  y: CGFloat(0 + rows * 80),
                                  width: 30,
                                  height: 80)
            let match = SingleMatchView(frame: position)
            addSubview(match)
        }

        // Currently visible number of matches.
        visibleMatches = matchNumber
    }

    /// Remove a given number of matches with animation.
    func removeMatches(_ matchNumber: Int) {
        // All currently registered matches (including animated ones).
        let oldMatches = subviews

        // Actual number of matches to remove.
        let actualNumber = (matchNumber > visibleMatches) ? visibleMatches : matchNumber

        let rotation = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        for index in 1...actualNumber {
            let lastIndex = visibleMatches - index
            let lastVisibleMatch = oldMatches[lastIndex]

            // Duration of rotation and fade transitions (in seconds, random).
            let rotateDuration = 1.0 + 0.1 * Double.random(in: 0...10)
            let fadeDuration = 0.5 + 0.1 * Double.random(in: 0...15)

            UIView.animate(withDuration: fadeDuration,
                    animations: { () in
                        lastVisibleMatch.alpha = 0.0
                    }, completion: { (_: Bool) in
                lastVisibleMatch.removeFromSuperview()
            })
            UIView.animate(withDuration: rotateDuration,
                    animations: { () in
                        lastVisibleMatch.transform = rotation
            })
        }

        // Finally, reduce the number of visible matches.
        visibleMatches -= matchNumber
    }
}
