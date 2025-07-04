//
//  Diagram.swift
//  Package-Mate
//
//  Created by Chris Milne on 27/05/2025.
//

import SwiftUI
import Foundation
import PDFKit

struct Diagram: View {
    @ObservedObject var IM: InputModel
    @Environment(\.dismiss) var dismiss
    @State private var showGenPDF = false
    @Binding var navPath: [NavTarget]
    
    var body: some View {
        VStack {
            DiagramContent(IM: IM)

            HStack(spacing: 1) {
                Button(action: {
                    showGenPDF = true
                }) {
                    CustomButton(label: " Make a PDF", width: 140, altColour: true)
  ///                  CustomButton(label: " Make a PDF", width: 140, altColour: true, logo: Image(systemName: "rectangle.and.pencil.and.ellipsis"))
                }
                .sheet(isPresented: $showGenPDF) {
                    GenPDF().environmentObject(IM)
                }

                Button(action: { dismiss() }) {
                    CustomButton(label: "Return", width: 80, logo: Image("arrow.uturn.backward"))
                        .padding()
                }
                // ✅ Show Info page via navPath
                Button(action: {
                    navPath.append(.info)
                }) {
                    CustomButton(label: "Info", width: 80, altColour: true, logo: Image(systemName: "questionmark.bubble"))
                }
            }
        }
    }
}

