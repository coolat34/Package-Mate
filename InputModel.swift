//
//  InputModel.swift
//  Package-Mate
//
//  Created by Chris Milne on 02/07/2025.
//

import Foundation
import Combine

public class InputModel: ObservableObject {
    @Published public var LengthSTR: String = ""
    @Published public var WidthSTR: String = ""
    @Published public var HeightSTR: String = ""
    @Published public var LengthACT: Double = 0.0
    @Published public var WidthACT: Double = 0.0
    @Published public var HeightACT: Double = 0.0
    @Published public var totwidth: Double = 0.0
    @Published public var totlength: Double = 0.0
 
    
    @Published public var CountryCode: String? = Locale.current.region?.identifier
    @Published public var measureSelected: String = "MTR"
    @Published public var note: String = "mtr"
    @Published public var measurements: [String] = ["MM", "CM", "MTR"]
    @Published public var notationAbr: [String] = ["mm", "cm", "mtr"]
    @Published public var selectedIndex = 0
    @Published public var USAregion: Bool = false
    
    public init() {}
    
    // Update the notationAbr  if the Measurement changes
    public func updateMeasurement(_ newMeasurement: String) {
        if let Mindex = measurements.firstIndex(of: newMeasurement) {
            note = notationAbr[Mindex]
            
            
        }
    }
    public func updateRegion(for system: String) {
        if system == "metric" {
            measureSelected = "MTR"
            note = "mtr"
            measurements = ["MM", "CM", "MTR"]
            notationAbr = ["mm", "cm", "mtr"]
        } else {
            measureSelected = "ft"
            note = "ft"
            measurements = ["Inches", "Feet"]
            notationAbr = ["in", "ft"]
        }
    }
    func syncNumericsFromStrings() {
        LengthACT = Double(LengthSTR) ?? 0.0
        WidthACT = Double(WidthSTR) ?? 0.0
        HeightACT = Double(HeightSTR) ?? 0.0
        return
    }
    
   
    
    func tabSequence() -> [FocusedField] {
        return [.LengthACT, .WidthACT, .HeightACT]
        }
    func reset() {
        LengthACT =  0.0
        WidthACT =  0.0
        HeightACT =  0.0
    }
}

