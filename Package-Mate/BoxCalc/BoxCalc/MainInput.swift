//
//  MainInput.swift
//  BoxCalc
//
//  Created by Chris Milne on 20/03/2024.
//

import SwiftUI
import PDFKit

class InputModel: ObservableObject {
    @Published var length: Int64 = 0
    @Published var width: Int64 = 0
    @Published var height: Int64 = 0
    @Published var showReturnKey: Bool = true
}

@MainActor
struct MainInput: View {
    let columns = [GridItem(.fixed(50)),
                    GridItem(.fixed(80)),
                    GridItem(.fixed(80))]
@FocusState private var focusedField: Bool // Used to dismiss Decimal Keypad
@Environment(\.dismiss) var dismiss
@StateObject var IM = InputModel()
    @State  var inputlength = ""
    @State  var inputwidth = ""
    @State  var inputheight = ""
    
    var body: some View {


            NavigationView {
                ZStack {
                    Color(red: 0.85, green: 0.95, blue: 0.99)
                        .edgesIgnoringSafeArea(.all)

                    
                    VStack(alignment: .center, spacing: 0) {
                        Image("80")
                            .imageScale(.small)
                            
                        
                        Text("Enter the Length, Width and Height \nof the item that you want to cover\n to the nearest millimetre \n and Press [View Packaging].\n")
                            .font(.title3)
                            .multilineTextAlignment(.center)
                            .frame(width: 330)
                        
                        Section {
                            
                            LazyVGrid(columns: columns, alignment:
                                        HorizontalAlignment.leading, spacing: 1)  {
                                Text("").gridCellColumns(1)
                                Text("Length")
                                    .gridCellColumns(2)
                                    .font(.system(.body))
                                TextField( "length", text: $inputlength)
                                    .keyboardType(.numberPad)
                                    .gridCellColumns(3)
                                    .fixedSize(horizontal: /*@START_MENU_TOKEN@*/false/*@END_MENU_TOKEN@*/, vertical: /*@START_MENU_TOKEN@*/false/*@END_MENU_TOKEN@*/)
                                    .textFieldStyle(.roundedBorder)
                                    .font(.system(.body))
                                    .focused($focusedField)
                                    .onChange(of: inputlength) {
                                        let filtered = inputlength.filter { "0123456789".contains($0) }
                                        IM.length = Int64(filtered) ?? 0
                                    }
                                
                                Text("").gridCellColumns(1)
                                Text("Width")
                                    .gridCellColumns(2)
                                    .font(.system(.body))
                                TextField("width", text: $inputwidth)
                                    .textFieldStyle(.roundedBorder)
                                    .gridCellColumns(3)
                                    .keyboardType(.numberPad)
                                    .font(.system(.body))
                                    .fixedSize(horizontal: false, vertical: false)
                                    .focused($focusedField)
                                    .onChange(of: inputwidth) {
                                        let filtered = inputwidth.filter { "0123456789".contains($0) }
                                        IM.width = Int64(filtered) ?? 0
                                    }
                                
                                Text("").gridCellColumns(1)
                                Text("Height")
                                    .gridCellColumns(2)
                                    .font(.system(.body))
                                TextField("height", text: $inputheight).textFieldStyle(.roundedBorder)
                                    .gridCellColumns(3)
                                    .keyboardType(.numberPad)
                                    .frame(height: 6)
                                    .font(.system(.body))
                                    .fixedSize(horizontal: false, vertical: false)
                                    .focused($focusedField)
                                    .onChange(of: inputheight) {
                                        let filtered = inputheight.filter { "0123456789".contains($0) }
                                        IM.height = Int64(filtered) ?? 0
                                    }
                            } /// VStack
                        } /// Section
                        .padding()
                        .padding()
                        
                        
                        
     //                   Button("Done") { focusedField = false }
                        HStack {
                            NavigationLink(destination: PackageDiagram(IM:IM, showReturnKey: true)
                                .environmentObject(IM)
                                .navigationBarBackButtonHidden(true)
                                .navigationBarTitleDisplayMode(.large)
                                .foregroundColor(Color(.black))
                            ) {
                CustomButton(label:"See Layout", width: 122, height: 30, logo:
                        Image("archivebox")) }
                            
            
                            Button(action: { dismiss() }) {
                CustomButton(label:"Return", width: 98, height: 30, logo:
                                Image("arrow.uturn.backward")) }
                            Button(action: { focusedField = false }
                            ) {
                CustomButton(label:"Done", width: 80, height: 30) }
                        }
                    }
            } /// NavView
            .navigationTitle("Package-Mate")
            .navigationBarTitleDisplayMode(.inline)
        } // ZStack
        } /// Body
} /// Struct

#Preview {
    NavigationView {
        MainInput()
    }
}
