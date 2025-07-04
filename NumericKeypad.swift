//
//  NumericKeypad.swift
//  Package-Mate
//
//  Created by Chris Milne on 02/07/2025.
//

import SwiftUI

struct NumericKeypad: View {
    @Binding var input: String
    
    /// Voids prevent a return type so that the NavStack doesn't get confused
    var onCommit: () -> Void
    var onTAB: () -> Void
    var onNext: () -> Void
    var onReset: () -> Void

    @Binding var navPath: [NavTarget]
    private let buttons = [
        ["1", "2", "3", "TAB"],
        ["4", "5", "6", "Clear"],
        ["7", "8", "9", "Next"],
        [".", "0", "⌫", "Reset"]
    ]

    var body: some View {
        VStack(spacing: 5) {
            ForEach(buttons, id: \.self) { row in
                HStack(spacing: 5) {
                    ForEach(row, id: \.self) { symbol in
                        Button(action: { handleTap(symbol) }) {
                            Text(symbol)
                                .font(.title2)
                                .foregroundStyle(.black)
                                .frame(width: 70, height: 40)
                                .background(Color.blue.opacity(0.1))
                                .border(Color.black, width: 1)
                                .cornerRadius(12)
                        }
                    }
                }
            }
        }
    }

    private func handleTap(_ symbol: String) {
        switch symbol {
        case "⌫":
            if !input.isEmpty { input.removeLast() }
        case ".":
            if !input.contains(".") { input.append(".") }
        case "Clear":
            input = ""
        case "TAB":
            onTAB()
 /* The DispatchQueue defers the navigation update until the UI has finished handling the tap gesture, which prevents crashes caused by modifying the navigation stack mid-animation. */
        case "Next":
  //          DispatchQueue.main.async {
  //              navPath.append(.next)
   //         }
            onNext()  /// Just set an object that can be interrogated in mainMenu
        case "Reset":
            onReset()
        default:
            input.append(symbol)
        }
    }
}
