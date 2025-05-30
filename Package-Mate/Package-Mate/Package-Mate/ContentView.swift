//
//  ContentView.swift
//  Package-Mate
//
//  Created by Chris Milne on 27/05/2025.
//

import SwiftUI
import Combine

struct ContentView: View {

    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 0.85, green: 0.95, blue: 0.99)
                    .edgesIgnoringSafeArea(.all)
                VStack(alignment: .center) {
                    Text("Want to send something by post and need to cover it in cardboard or stiff paper first. \n\nThis handy tool will help you. \nIt will calculate the amount of \nCardboard or Stiff Paper required \n to cover a package")
                   //     .font(.title3)
                        .bold()
                        .multilineTextAlignment(.center)
                        .frame(width: 330)
                    
                    Image("80")
                        .imageScale(.small)
                        .padding()
                    Text("Enter, in millimetres, the Length, \nWidth and Height of the item \nthat you want to cover. \n The screen will then display a view of the covering. \n Then Generate a PDF. \n The PDF can be either Copied to Whatsapp or Emailed,\nPrinted or Saved.")
         //               .font(.title3)
                        .bold()
                        .multilineTextAlignment(.center)
                        .frame(width: 330)
                    
                    
                    NavigationLink(
                        destination: MainInput()
                            .navigationBarBackButtonHidden(true)
                        
                    )
                    {
                        CustomButton(label: "Continue", width: 300, logo: Image("arrow.uturn.right"))
                            .padding()
                    }  /// CustomButton
                } /// VStack
            } /// NavView
            .navigationTitle("Package-Mate")
            .navigationBarTitleDisplayMode(.inline)


        } /// ZStack
    } /// Body
} /// Struct
#Preview {
    ContentView()
      
}

