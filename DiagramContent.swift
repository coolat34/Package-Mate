//
//  DiagramContent.swift
//  Package-Mate
//
//  Created by Chris Milne on 01/06/2025.
//

import SwiftUI

struct DiagramContent: View {
    @ObservedObject var IM: InputModel

    var body: some View {

        VStack(spacing: 1) {
            Section {
                Text("Cut a piece of Cardboard or Stiff \npaper " +
                     (String(format: "%.2f", (IM.LengthACT * 2) +
                             (IM.HeightACT * 2))) +
                     (" \(IM.note) long and ") +
                     (String(format: "%.2f", (IM.WidthACT + (IM.HeightACT * 2)))) +
                     (" \(IM.note) wide\nand follow the diagram below"))
                    .font(.body)
                    .background(Colors.lightGray)
                    .foregroundColor(Colors.black)
                    .multilineTextAlignment(.center)
                    .border(Color.black, width: 1)
                    .frame(maxWidth: .infinity)
            }

        Text("\n" +
             (String(format: "%.2f", IM.HeightACT)) +
             "    " +
             (String(format: "%.2f", IM.WidthACT)) +
             "       " +
             (String(format: "%.2f", IM.HeightACT)))
        .multilineTextAlignment(.center)
       

            Image("CardBoardMedium")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 400, maxHeight: 295)

            ForEach(1..<5) { tag in
                let side = sides(tag)
                let pos = placement(tag)
                Text(String(format: "%.2f", side))
                    .foregroundStyle(.black)
                    .font(.body)
                    .offset(x: CGFloat(pos.x1), y: CGFloat(pos.y1))
            }

            Section {
                VStack {
                    Text("Crease the Covering on the Crease lines \nNow cut the Covering \non both sides where it shows CUT.")
                }
                .font(.body)
                .background(Colors.lightGray)
                .foregroundColor(Colors.black)
                .multilineTextAlignment(.center)
                .border(Color.black, width: 1)
                .frame(maxWidth: .infinity)
                .navigationBarBackButtonHidden(true)
            }
        }
    }
func sides(_ tag: Int) -> Double {
    if tag % 2 == 0 {
        return IM.LengthACT
    } else {
        return IM.HeightACT
    }
    }

    func placement(_ tag: Int) -> (x1: Int, y1: Int) {
        switch tag {
        case 1: return (118, -275)
        case 2: return (118, -230)
        case 3: return (118, -180)
        case 4: return (118, -135)
        default: return (0, 0)
        }
    }
}

#Preview {
    DiagramContent(IM: InputModel())
}
