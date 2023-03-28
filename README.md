# MVVM and FRP: Architectures for Mobile Apps

![Swift 5.7](https://img.shields.io/badge/Swift-5.7-orange.svg) ![platforms](https://img.shields.io/badge/platforms-iOS-lightgrey.svg) [![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/field-theory-org/match-game-architecture/main/LICENSE) ![Build status](https://github.com/field-theory-org/match-game-architecture/actions/workflows/build-test.yml/badge.svg)

This source code repository accompanies my blog posts on the MVVM
(Model-View-View Model) architecture and the FRP (Functional Reactive
Programming) paradigm. You can find the related posts on my blog:

* [Part 1](https://field-theory.org/posts/mvvm-frp-architectures-pt-1.html),
* [Modules](https://field-theory.org/posts/using-swift-modules.html),
* [Part 2](https://field-theory.org/posts/mvvm-frp-architectures-pt-2.html).

These files are an updated version of a presentation at the
[Developer Week 2016](http://www.developer-week.de) conference, Nuremberg,
Germany. See http://dwx2016.nua-schroers.de for further information
(in German).

I have updated the project to run with Swift 5.7 on Xcode 14.

## The Match Game

The Match Game app illustrates the concepts by implementing a simple
game using different architectures and paradigms.

## Installation and Use

The source code is organized in different sub-folders, code shared by
all apps is in the `01_Common` folder. The command line app for macOS
is in the `10_Commandline-App` folder, the basic MVC-based app in
`20_Basic-App`, and the MVVM-based app in `30_MVVM-App`.

The MVVM-FRP-based app is in `40_MVVM_FRP-App`.

Each of these folders has a sub-folder called `MatchGame`. To open the
corresponding project open the workspace file `MatchGame.xcworkspace`
in the corresponding sub-folder.

Previously, I had used CocoaPods to manage the dependencies in the FRP
installment, but I have recently switched to Swift Package Manager. I
have left the `Podfile` in place for reference purposes, but it is no
longer needed.

## License and Attribution

Documentation and associated written materials are subject to the
[CC BY-NC-SA 4.0 license](https://creativecommons.org/licenses/by-nc-sa/4.0/).

The accompanying software is copyright (c) 2012-2023 Dr. Wolfram
Schroers, [cdr-fn GmbH](https://cdr-fn.com) and subject to the
conditions in the file `LICENSE`.

The launch image and the icons are modified copies of a photo by Derek
Gavey which has been licensed under the
[CC-BY 2.0 license](https://creativecommons.org/licenses/by/2.0/).
The photo is available
on [Flikr](https://www.flickr.com/photos/derekgavey/6068317482/in/photolist-afeHnu-dMRh3f-cMzkD7-anpD7m-cMzmb1-cMzkSC-cMzkL1-7JK2PQ-eUFjFB-6ZQjg-eMHzom-k1Zee3-aMFVAe-8L2DU7-nB2Gwq-ESkxeS-dMFLbJ-838DFC-dsaPqJ-9HzTP4-6V5jtx-6JPnvN-okwZka-DJk-pWdwJK-8cJ4gS-ozmrHo-krczSP-ikFion-9HgNMm-bHk1Pc-7JF7dx-yZs8f-6k4EGJ-6msS1R-6AK9Vu-k6iRYW-jAEaKT-6AF3Sa-btkq1c-6AF2cv-6AKd2h-6AK8Qu-dz4cat-6G73ii-5Syqj7-pZFQKz-onzJgm-f7UZ3i-6AF1X6).

