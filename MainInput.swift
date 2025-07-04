//
//  MainInput.swift
//  Package-Mate
//
//  Created by Chris Milne on 27/05/2025.
//

import SwiftUI
import Foundation

enum NavTarget: Hashable {
case next
case info
}
enum FocusedField: Hashable {
case LengthACT, WidthACT, HeightACT
}

// @MainActor
struct MainInput: View {
let columns = [GridItem(.fixed(10)), 
       GridItem(.fixed(100)),
       GridItem(.fixed(80))]
@State private var navPath: [NavTarget] = []
///@Environment(\.dismiss) var dismiss
@StateObject var IM = InputModel()
@AppStorage("PreferredUnit") var PreferredUnit: String = Locale.current.region?.identifier == "US" ? "imperial" : "metric"
@State private var Inputvalue: String = ""
@State var Outputvalue: Double = 0.0
@State private var activeField: FocusedField = .LengthACT
@FocusState private var focusedField: Bool /// Used to dismiss the Decimal Keypad
/// @Binding  var navPath: [NavTarget] /// Holds destinations. E.G LastScreen or NextScreen
@State var isStyled: Bool = false /// Style applied to the active input field


var body: some View {
NavigationStack(path: $navPath) {

ZStack {
    Color(red: 0.85, green: 0.95, blue: 0.99)
        .edgesIgnoringSafeArea(.all)
    
    VStack(alignment: .center, spacing: 5) {

       Image("80")
           .resizable()
         .scaledToFit()
            .frame(maxWidth: 60, maxHeight: 80)
          .padding(1)
        
        Text("\nEnter the Length, Width and Height\nof the item that you want to cover\n to the nearest \(IM.note) and Press NEXT")
            .multilineTextAlignment(.center)
            .padding(1)
        // Amend preferrence of Metric or Imperial
        Picker("Units", selection: $PreferredUnit) {
            Text("Metric").tag("metric")
            Text("Imperial").tag("imperial")
        } /// Picker
        .pickerStyle(SegmentedPickerStyle())
        .frame(width: 300)
      .padding(1)
        .onChange(of: PreferredUnit) {
            IM.updateRegion(for: PreferredUnit)
        } /// onChange of
        
        // MARK: Amend preference of Metres, Centimetres or Millimetres
        Picker("Measurement", selection: $IM.measureSelected) {
            ForEach(IM.measurements, id: \.self) { Text($0) }
        }/// Picker
        .pickerStyle(.segmented)
        .frame(width: 300)
      .padding(1)
        // Use onChange of for Picker
        .onChange(of: IM.measureSelected) {
            IM.updateMeasurement(IM.measureSelected)
        } // on Change of
//    } // VStack
        
        
        //MARK: Measurement Input
        
            KeyPadInput(text: $IM.LengthSTR, isStyled: activeField == .LengthACT, label: "  Length",  unit: IM.note)
                .frame(height: 30)
                .focused($focusedField)
                .onChange(of: IM.LengthSTR) {
                    IM.LengthACT = Double(IM.LengthSTR) ?? 0
                }
            
            KeyPadInput(text: $IM.WidthSTR, isStyled: activeField == .WidthACT, label: "  Width",  unit: IM.note)
                .frame(height: 30)
                .focused($focusedField)
                .onChange(of: IM.WidthSTR) {
                    IM.WidthACT = Double(IM.WidthSTR) ?? 0
                }
            
            KeyPadInput(text: $IM.HeightSTR, isStyled: activeField == .HeightACT, label: "  Height",  unit: IM.note)
                .frame(height: 30)
                .focused($focusedField)
                .onChange(of: IM.HeightSTR) {
                    IM.HeightACT = Double(IM.HeightSTR) ?? 0
                }
               .padding(.horizontal, 1)
                .navigationBarBackButtonHidden(true)
                .onAppear {
                    activeField = .LengthACT
                } // on Appear
            
            /// activeInputBinding Lets numeric keypad dynamically update the currently active field
            var activeInputBinding: Binding<String> {
                switch activeField {
                case .LengthACT:
                    return $IM.LengthSTR
                case .WidthACT:
                    return $IM.WidthSTR
                case .HeightACT:
                    return $IM.HeightSTR
                } ///Switch
            } /// var active
            
            NumericKeypad(
                input: activeInputBinding,
                onCommit: {
                    IM.syncNumericsFromStrings()  /// Convert the input strings to numbers
                }, ///onCommit
                
                onTAB: {
                    withAnimation {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                            
                            let sequence = IM.tabSequence() /// Select correct input fields for each shape
                            if let currentIndex = sequence.firstIndex(of: activeField) { /// No of current field
                                let nextIndex = (currentIndex + 1) % sequence.count /// Get remainder of next no / total
                                activeField = sequence[nextIndex]  /// Get next input field if remainder < 1
                            } else {
                                activeField = sequence.first ?? .LengthACT /// or go back to 1st input field
                            } /// 3
                        } /// 2
                    }  /// 1
                }, /// onTab
                onNext: {
                    navPath.append(.next)
                },
                onReset: {
                    IM.LengthSTR = ""
                    IM.WidthSTR = ""
                    IM.HeightSTR = ""
                },
                navPath: $navPath

            ) /// Numeric KeyPad
            .navigationDestination(for: NavTarget.self) { target in
                switch target {
                case .next:
                    Diagram(IM: IM, navPath: $navPath)
                case .info:
                    Info(navPath: $navPath)
 //               default: EmptyView()
                }
            }
          
        } // VStack
        .padding(40)
    }  // ZStack
    
    .zIndex(1)
    // Display error messages after the last Vstack and before the last ZStack. Ensures that the  rendering takes precedence over the current display
    
  } /// NavView
.navigationTitle("Package-Mate")
.navigationBarTitleDisplayMode(.inline)

} /// Body
} /// Struct

#Preview {
//NavigationView {
MainInput()
}
//}
