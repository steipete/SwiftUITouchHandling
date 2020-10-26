//
//  SwiftUIView.swift
//  SwiftUITouchHandling
//
//  Created by Peter Steinberger on 26.10.20.
//

import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        VStack {
            Button("SwiftUI Button") {
                print("SwiftUI tapped")
            }.border(Color.black)
        }.frame(minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .center
        ).background(Color.red)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
