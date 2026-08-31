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

## Building and testing

The sample uses Apple's UIKit and SwiftUI frameworks, with no third-party dependencies.
Open `SwiftUITouchHandling.xcodeproj` and run the `SwiftUITouchHandling` scheme on an iOS simulator.

For the same validation used by CI, install Xcode with the iOS 26.5 simulator runtime and run:

```sh
./scripts/ci.sh
```

The script builds and runs all XCTest tests in Debug, builds Release for iOS devices and the simulator, then installs and launches the Release app and checks that it stays running. The tests exercise touch forwarding through an overlapping UIKit view hierarchy, including changes to the active rectangle. The script creates its own simulator and removes it and its build products on exit. Set `SIMULATOR_RUNTIME` to a different installed runtime identifier if needed.

GitHub Actions runs this build/test/launch check on pull requests and pushes to `main`, using Xcode 26.6 on macOS 26. No signing credentials are needed for these simulator and compile-only device builds.
