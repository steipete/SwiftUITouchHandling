//
//  SwiftUIView.swift
//  SwiftUITouchHandling
//
//  Created by Peter Steinberger on 26.10.20.
//

import SwiftUI


struct SwiftUIView: View {

    /// Using an optional `CGRect` is a matter of personal preference.
    private struct ButtonRectPreferenceKey: PreferenceKey {
        static func reduce(value: inout CGRect?, nextValue: () -> CGRect?) {
            /// We set it once and for all. It won't change so no need for `onPreferenceChange` to be re-evaluated.
            value = nextValue() ?? value
        }
    }
    
    let activeRectBox: CGRectBox
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Button("SwiftUI Button") {
                    print("SwiftUI tapped")
                }
                // Making the button frame bubble up.
                .anchorPreference(key: ButtonRectPreferenceKey.self, value: Anchor<CGRect>.Source.bounds) { proxy[$0] }
                .border(Color.black)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.red)
        }
        // Catching the button frame.
        .onPreferenceChange(ButtonRectPreferenceKey.self) { activeRectBox.rect = $0 }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView(activeRectBox: .init())
    }
}
