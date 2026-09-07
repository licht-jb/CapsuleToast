import XCTest

@MainActor
final class CapsuleToastDemoUITests: XCTestCase {
    private let savedLabel = "Saved, Your changes are ready."

    func testTapDismissesAndUpdatesAppState() {
        let app = launch()
        app.buttons["Show saved toast"].tap()
        let toast = app.buttons[savedLabel]
        XCTAssertTrue(toast.waitForExistence(timeout: 3))
        XCTAssertTrue(app.buttons["Show another toast"].isHittable)
        toast.tap()
        XCTAssertTrue(toast.waitForNonExistence(timeout: 3))
        XCTAssertEqual(app.staticTexts["toast-state"].label, "Current toast: none")
    }

    func testUpwardSwipeDismisses() {
        let app = launch()
        app.buttons["Show saved toast"].tap()
        let toast = app.buttons[savedLabel]
        XCTAssertTrue(toast.waitForExistence(timeout: 3))
        let start = toast.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        start.press(forDuration: 0.05, thenDragTo: start.withOffset(CGVector(dx: 0, dy: -60)))
        XCTAssertTrue(toast.waitForNonExistence(timeout: 3))
        XCTAssertEqual(app.staticTexts["toast-state"].label, "Current toast: none")
    }

    func testDownwardDragKeepsToastOpen() {
        let app = launch()
        for distance in [20.0, 100.0] {
            app.buttons["Show saved toast"].tap()
            let toast = app.buttons[savedLabel]
            XCTAssertTrue(toast.waitForExistence(timeout: 3))
            let start = toast.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
            start.press(forDuration: 0.05, thenDragTo: start.withOffset(CGVector(dx: 0, dy: distance)))
            XCTAssertTrue(toast.exists, "A downward drag of \(distance) points must keep the toast open")
            XCTAssertEqual(app.staticTexts["toast-state"].label, "Current toast: Saved")
            toast.tap()
            XCTAssertTrue(toast.waitForNonExistence(timeout: 3))
        }
    }

    func testReplacementAndRepeatedPresentation() {
        let app = launch()
        app.buttons["Show saved toast"].tap()
        let savedToast = app.buttons[savedLabel]
        XCTAssertTrue(savedToast.waitForExistence(timeout: 3))
        app.buttons["Show saved toast"].tap()
        XCTAssertTrue(savedToast.waitForExistence(timeout: 3))
        XCTAssertEqual(app.buttons.matching(identifier: savedLabel).count, 1)
        app.buttons["Show another toast"].tap()
        let replacement = app.buttons["Download complete, The file is available offline."]
        XCTAssertTrue(replacement.waitForExistence(timeout: 3))
        XCTAssertTrue(savedToast.waitForNonExistence(timeout: 3))
        app.buttons["Dismiss from app"].tap()
        XCTAssertTrue(replacement.waitForNonExistence(timeout: 3))
        app.buttons["Show saved toast"].tap()
        XCTAssertTrue(savedToast.waitForExistence(timeout: 3))
    }

    private func launch() -> XCUIApplication {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
        return app
    }
}
