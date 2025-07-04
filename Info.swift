//
//  ContentView.swift
//  Package-Mate
//
//  Created by Chris Milne on 27/05/2025.
//

import SwiftUI


struct Info: View {
    @Binding var navPath: [NavTarget]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.85, green: 0.95, blue: 0.99)
                    .edgesIgnoringSafeArea(.all)
                VStack(alignment: .center) {
                    Text("Want to send something by post and need to cover it in cardboard or stiff paper first. \n\nThis handy tool will help you. \nIt will calculate the amount of \nCardboard or Stiff Paper required \n to cover a package.\n\nSelect a Unit, Metric will give you millimetres, centimetres or metres. Imperial will give you feet or inches.\nEnter the Length, \nWidth and Height of the item \nthat you want to cover. \n The screen will then display a view of the covering. \n Then Make a PDF. \n The PDF can be either Copied to Whatsapp or Emailed,\nPrinted or Saved.")
         //               .font(.title3)
                        .bold()
                        .multilineTextAlignment(.center)
                        .frame(width: 330)
                    Button(action: {
                        navPath.removeLast()
                    }) {
                        CustomButton(label: "Return", width: 80, altColour: true, logo: Image(systemName: "arrow.uturn.backward"))
                    }
                } /// VStack
            } /// NavView
            .navigationTitle("Package-Mate")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)

        } /// ZStack
    } /// Body
} /// Struct


