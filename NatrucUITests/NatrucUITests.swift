//
//  NatrucUITests.swift
//  NatrucUITests
//
//  Created by Korejtko Jiří on 31.07.16.
//  Copyright © 2016 Jiri Dutkevic. All rights reserved.
//

import XCTest

class NatrucUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        let app = XCUIApplication()
        // Initialize Fastlane Snapshot
        setupSnapshot(app)
        
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTakeScreenshots() {
        let app = XCUIApplication()
        snapshot("1_Now")
        
        app.tabBars.buttons["Program"].tap()
        scrollTo("Brutální Jahoda", collectionViewElement: app.tables.element(boundBy: 0), scrollUp: false, fullyVisible: true)
        
        snapshot("2_Program")
        
        app.tables.staticTexts["Tata Bojs"].tap()
        snapshot("3_BandDetail")
        
        app.tabBars.buttons.element(boundBy: 2).tap()
        snapshot("4_Map")
        
        app.tabBars.buttons["Info"].tap()
        scrollTo("Vlakem", collectionViewElement: app.tables.element(boundBy: 0), scrollUp: false, fullyVisible: true)

        snapshot("5_Info")
    }
}

func scrollTo(_ cellIdentifier: String, collectionViewElement: XCUIElement, scrollUp: Bool = false, fullyVisible: Bool = false) -> Bool {
    var rtn = false
    var lastMidCellID = ""
    var lastMidCellRect = CGRect.zero
    
    var currentMidCell = collectionViewElement.cells.element(boundBy: collectionViewElement.cells.count / 2)
    
    // Scroll until the requested cell is hittable, or until we try and scroll but nothing changes
    
    while (lastMidCellID != currentMidCell.identifier || !lastMidCellRect.equalTo(currentMidCell.frame)) {
        
        if (collectionViewElement.cells.matching(identifier: cellIdentifier).count > 0 && collectionViewElement.cells[cellIdentifier].exists && collectionViewElement.cells[cellIdentifier].isHittable) {
            rtn = true
            break;
        }
        
        lastMidCellID = currentMidCell.identifier
        lastMidCellRect = currentMidCell.frame      // Need to capture this before the scroll
        
        if (scrollUp) {
            collectionViewElement.coordinate(withNormalizedOffset: CGVector(dx: 0.99, dy: 0.4)).press(forDuration: 0.01, thenDragTo: collectionViewElement.coordinate(withNormalizedOffset: CGVector(dx: 0.99, dy: 0.9)))
        }
        else {
            collectionViewElement.coordinate(withNormalizedOffset: CGVector(dx: 0.99, dy: 0.9)).press(forDuration: 0.01, thenDragTo: collectionViewElement.coordinate(withNormalizedOffset: CGVector(dx: 0.99, dy: 0.4)))
        }
        
        currentMidCell = collectionViewElement.cells.element(boundBy: collectionViewElement.cells.count / 2)
    }
    
    
    // If we want cell fully visible, do finer scrolling (1/2 height of cell relative to collection view) until cell frame fully contained by collection view frame
    
    if (fullyVisible) {
        let cell = collectionViewElement.cells[cellIdentifier]
        let scrollDistance = (cell.frame.height / 2) / collectionViewElement.frame.height
        
        while (!collectionViewElement.frame.contains(cell.frame)) {
            if (cell.frame.minY < collectionViewElement.frame.minY) {
                collectionViewElement.coordinate(withNormalizedOffset: CGVector(dx: 0.99, dy: 0.5)).press(forDuration: 0.01, thenDragTo: collectionViewElement.coordinate(withNormalizedOffset: CGVector(dx: 0.99, dy: 0.5 + scrollDistance)))
            }
            else {
                collectionViewElement.coordinate(withNormalizedOffset: CGVector(dx: 0.99, dy: 0.5)).press(forDuration: 0.01, thenDragTo: collectionViewElement.coordinate(withNormalizedOffset: CGVector(dx: 0.99, dy: 0.5 - scrollDistance)))
            }
        }
    }
    
    return rtn;
}
