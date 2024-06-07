//
//  Artist.swift
//  SV3
//
//  Created by Travis Domenic Ratliff on 3/11/24.
//

import Foundation
import Observation

class Artist: ObservableObject {
    @Published var list = [String]()
}
