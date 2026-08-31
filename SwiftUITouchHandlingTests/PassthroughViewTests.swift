import UIKit
import XCTest
@testable import SwiftUITouchHandling

@MainActor
final class PassthroughViewTests: XCTestCase {
    private let activeRect = CGRect(x: 30, y: 40, width: 80, height: 30)

    private func makeHierarchy() -> (UIView, UIButton, PassthroughView, UIButton, CGRectBox) {
        let root = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
        let underlyingButton = UIButton(frame: root.bounds)
        root.addSubview(underlyingButton)

        let box = CGRectBox()
        let overlay = PassthroughView(activeRectBox: box)
        overlay.frame = CGRect(x: 100, y: 100, width: 150, height: 150)
        let overlayButton = UIButton(frame: activeRect)
        overlay.addSubview(overlayButton)
        root.addSubview(overlay)
        return (root, underlyingButton, overlay, overlayButton, box)
    }

    func testTouchesPassThroughBeforeSwiftUILayoutReportsAnActiveRect() {
        let (root, underlyingButton, overlay, _, _) = makeHierarchy()
        let point = overlay.convert(CGPoint(x: activeRect.midX, y: activeRect.midY), to: root)

        XCTAssertTrue(root.hitTest(point, with: nil) === underlyingButton)
    }

    func testOnlyTheActiveRectInterceptsTouches() {
        let (root, underlyingButton, overlay, overlayButton, box) = makeHierarchy()
        box.rect = activeRect
        let activePoint = overlay.convert(CGPoint(x: activeRect.midX, y: activeRect.midY), to: root)
        let backgroundPoint = overlay.convert(CGPoint(x: 10, y: 10), to: root)

        XCTAssertTrue(root.hitTest(activePoint, with: nil) === overlayButton)
        XCTAssertTrue(root.hitTest(backgroundPoint, with: nil) === underlyingButton)
        XCTAssertTrue(root.hitTest(CGPoint(x: 20, y: 20), with: nil) === underlyingButton)
    }

    func testHitTestingTracksLayoutChangesAndRemoval() {
        let (root, underlyingButton, overlay, overlayButton, box) = makeHierarchy()
        box.rect = activeRect
        let oldPoint = overlay.convert(CGPoint(x: activeRect.midX, y: activeRect.midY), to: root)
        let movedRect = activeRect.offsetBy(dx: 0, dy: 60)
        overlayButton.frame = movedRect
        box.rect = movedRect
        let newPoint = overlay.convert(CGPoint(x: movedRect.midX, y: movedRect.midY), to: root)

        XCTAssertTrue(root.hitTest(oldPoint, with: nil) === underlyingButton)
        XCTAssertTrue(root.hitTest(newPoint, with: nil) === overlayButton)

        box.rect = nil
        XCTAssertTrue(root.hitTest(newPoint, with: nil) === underlyingButton)
    }
}
