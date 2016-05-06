//
//  ViewControllerTests.swift
//  TwentyFourHours
//
//  Created by Vincent O'Sullivan on 05/05/2016.
//  Copyright © 2016 Vincent O'Sullivan. All rights reserved.
//

import XCTest
@testable import TwentyFourHours

class ViewControllerTests: XCTestCase {

    private var viewController: ViewController!

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "Main",
                                      bundle: NSBundle.mainBundle())
        viewController = storyboard.instantiateInitialViewController() as! ViewController

        UIApplication.sharedApplication().keyWindow!.rootViewController = viewController

        // The One Weird Trick!
        let _ = viewController.view
    }

    func testCreatable() {
        XCTAssertNotNil(viewController)
    }
}
