//
//  SwiftUIView.swift
//  SwiftUITouchHandling
//
//  Created by Peter Steinberger on 26.10.20.
//

import SwiftUI

struct SwiftUIView: View {
    private struct ButtonRectPreferenceKey: PreferenceKey {
        static var defaultValue: CGRect? { nil }

        static func reduce(value: inout CGRect?, nextValue: () -> CGRect?) {
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
                .anchorPreference(key: ButtonRectPreferenceKey.self, value: Anchor<CGRect>.Source.bounds) { proxy[$0] }
                .border(Color.black)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.red)
        }
        .onPreferenceChange(ButtonRectPreferenceKey.self) { activeRectBox.rect = $0 }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView(activeRectBox: .init())
    }
}
