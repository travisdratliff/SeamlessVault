//
//  Settings.swift
//  SV3
//
//  Created by Travis Domenic Ratliff on 3/23/24.
//

import Foundation
import Observation
import SwiftUI

@Observable
class ColorMode {
    var lightMode: Bool {
        get {
            access(keyPath: \.lightMode)
            return UserDefaults.standard.value(forKey: "lightMode") as? Bool ?? false
        }
        set {
            withMutation(keyPath: \.lightMode) {
                UserDefaults.standard.set(newValue, forKey: "lightMode")
            }
        }
    }
}

@Observable
class LogoColor {
    var logoColor: [CGFloat] {
        get {
            access(keyPath: \.logoColor)
            return UserDefaults.standard.value(forKey: "logoColor") as? [CGFloat] ?? [1, 0.41, 0.38, 1]
        }
        set {
            withMutation(keyPath: \.logoColor) {
                UserDefaults.standard.set(newValue, forKey: "logoColor")
            }
        }
    }
}
