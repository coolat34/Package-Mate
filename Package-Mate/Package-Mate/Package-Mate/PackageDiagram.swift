//
//  PackageDiagram.swift
//  Package-Mate
//
//  Created by Chris Milne on 27/05/2025.
//

import SwiftUI
import Foundation
import PDFKit

struct PackageDiagram: View {
    
    
    @ObservedObject var IM: InputModel
    @Environment(\.dismiss) var dismiss
    let columns = [GridItem(.fixed(65)),
                   GridItem(.fixed(70)),
                   GridItem(.fixed(70)),
                   GridItem(.fixed(70))]
    @State var dlength: Int64 = 0
    @State var flaps: Int64 = 0
    @State private var pdfURL: URL?
    @State private var showGenPDF = false
    var showReturnKey: Bool
    
    var body: some View {
        
        let (calcLength, calcFlaps, dwidth) = areaCalc(length: IM.length, width: IM.width, height: IM.height)
        
        VStack(spacing: 0) {
            Section {
                Text(" Values on the diagram are in millimetres \n Cut a piece of Cardboard or Stiff \npaper \(calcLength)mm wide and \(dwidth)mm long\n and follow the diagram below \n")
                    .font(.body)
                    .background(Colors.lightGray)
                    .foregroundColor(Colors.black)
                    .multilineTextAlignment(.center)
                    .border(Color.black, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                    .frame(width: 400)
                //  .padding()
            } /// Section
            
   /// X-axis is Horizontal Y-axis is Vertical
       Text("Flap        Cover        Flap\n  Width      Width       Width\n\(calcFlaps)mm       \(dwidth)mm       \(calcFlaps)mm ")
            
            .multilineTextAlignment(.center)
            .foregroundStyle(.black)
            .font(.body)
            .background(Colors.white)
            .frame(width: 250, height: 70)
            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 1)
            .ignoresSafeArea()
            

        } /// VStack
        
        /// X-axis is Horizontal Y-axis is Vertical
        ForEach(1..<6) { tag in
            /// Function calcs the length of sides
            let sideLength = sideCalc(tag: tag, width: IM.width, height: IM.height)
            HStack(spacing: 2) {
                Text("            ");
                /// Geometry Reader uses the available width of the screen.
                GeometryReader { geo in
                    if tag < 5 {
                        Text("CUT")
                            .foregroundStyle(.black)
                            .offset(x: -40, y:37.5)
                        //    .offset(x: -40, y:30)
                    } /// If
                } /// Geo Reader
                .background(Colors.brown)
                .frame(width: 50, height: 40)
                .font(.body)
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 1)
                .ignoresSafeArea()
                
                GeometryReader { geo in
                    if tag < 5 {
                        Text("-----Crease----")
                            .foregroundStyle(.black)
                            .font(.footnote)
                            .offset(x: 6.0, y:37.5)
                          //  .offset(x: 8, y:35)
                    } /// If
                }   /// Geometry Reader
                .background(Colors.brown)
                .frame(width: 100, height: 40)
              .overlay(
                    RoundedRectangle(cornerRadius: 1)
                        .stroke(Color.black, lineWidth: 1)
                        .frame(width: 100, height: 40)
                    /// Adjust y: value to control the thickness of the border
                   //     .offset(y: 1)
                )
                GeometryReader { geo in
                    Text("\(sideLength)")
                        .background(Color.white)
                    ///                                .rotationEffect(.degrees(+90))
                        .font(.body)
                        .offset(x:52, y:12)
                    
                    if tag < 5 {
                        Text("CUT")           /// RightHand side
                            .foregroundStyle(.black)
                            .offset(x: 52, y:37.5)
                       //     .offset(x: 52, y:30)
                    } /// If
                } //// geometry Reader
                /// Right Flap
                .background(Colors.brown)
                .frame(width: 50, height: 40)
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                Text("             ");
            } /// HStack
            .font(.body)
        }  /// ForEach
        
        
        Section {
            Text("")
            VStack() {
                
                Text("Crease the Covering on the Crease lines \nNow cut the Covering by \(calcFlaps) millimetres\n on both sides where it shows CUT.")
                
            } /// VStack
        } /// Section
        .font(.body)
        .background(Colors.lightGray)
        .foregroundColor(Colors.black)
        .multilineTextAlignment(.center)
        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
        .frame(width: 400)
        .padding()
        
        HStack {
           
           
             Button(action: {
             showGenPDF = true
             }) {
                 CustomButton(label: " Generate a PDF", width: 180, altColour: true,  logo: Image(systemName: "rectangle.and.pencil.and.ellipsis"))
             }
             .sheet(isPresented: $showGenPDF) {
             GenPDF()
             .environmentObject(IM)
             }
             
            Button(action: { dismiss() }) {
                CustomButton(label:"Return", width: 100, logo:
                                Image("arrow.uturn.backward")).padding()
            }
        }
    }
    
    
    func areaCalc(length: Int64, width: Int64, height: Int64) -> (dlength: Int64, flaps: Int64, dwidth: Int64) {
        
        let dwidth: Int64 = (width * 2) + (height * 3)
        if width < height {
            let dlength = length + (width * 2)
            let flaps = width
            return (dlength, flaps, dwidth)
        } else {
            let dlength = length + (height * 2)
            let flaps = height
            return (dlength, flaps, dwidth)
        } /// else
    } /// func
    
    func sideCalc(tag: Int, width: Int64, height: Int64) -> Int64 {
        return tag % 2 == 0 ? width : height
    }
    
}
#Preview {
    PackageDiagram(IM: InputModel(), showReturnKey: true)
    }
