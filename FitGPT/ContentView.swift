//
//  ContentView.swift
//  FitGPT
//
//  Created by Brian Smith on 7/13/25.
//

import SwiftUI

enum Emoji: String {
    case standingMan = "🧍‍♂️"
}

struct ContentView: View {
    var selection: Emoji = .standingMan
    
    var body: some View {
        VStack {
            Text(selection.rawValue)
                .font(.system(size:120))
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
