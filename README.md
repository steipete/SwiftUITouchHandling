# SwiftUITouchHandling

This examples features an UIKit view and a SwiftUI view.

The goal is that areas in SwiftUI that don't process touches should forward touches to the underlying UIView.

Currently the area that is wrapped SwiftUI always consumes touches. In UIKIt this can be prevented via setting `userInteractionEnabled` = false.

In SwiftUI there's

* `.disabled(true)`
* `.allowsHitTesting(false)`

But neither does block touches. If we set `swiftUI.view.isUserInteractionEnabled = false` then touches are forwarded, but the whole item isn't participating in touch forwarding.

**This means that SwiftUI views that are partially transparent can't easily be mixed with UIKit, as they still block touch handling for whatever they overlay.**

Or maybe there's a way?