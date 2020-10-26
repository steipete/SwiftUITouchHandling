# SwiftUITouchHandling

This examples features an UIKit view and a SwiftUI view.

The goal is that areas in SwiftUI that don't process touches should forward touches to the underlying UIView.

![](https://p197.p4.n0.cdn.getcloudapp.com/items/WnurDvEg/Screen%20Shot%202020-10-26%20at%2013.32.01.png?source=viewer&v=c0e5b3f9f1d5efd62dcc061843930e22)

Currently the area that is wrapped SwiftUI always consumes touches. In UIKIt this can be prevented via setting `userInteractionEnabled` = false.

In SwiftUI there's

* `.disabled(true)`
* `.allowsHitTesting(false)`

But neither does block touches. If we set `swiftUI.view.isUserInteractionEnabled = false` then touches are forwarded, but the whole item isn't participating in touch forwarding.

**This means that SwiftUI views that are partially transparent can't easily be mixed with UIKit, as they still block touch handling for whatever they overlay.**

Or maybe there's a way?
