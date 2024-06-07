//
//  Extensions.swift
//  SV3
//
//  Created by Travis Domenic Ratliff on 3/6/24.
//

import Foundation
import SwiftUI

extension String {
    var isReallyEmpty: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

extension Array where Element == String {
    func filterTags(text: String) -> Bool {
        for i in self.sorted() {
            if !i.lowercased().contains(text.lowercased().trimmingCharacters(in: .whitespaces)) {
                continue
            } else {
                return true
            }
        }
        return false
    }
}

extension View {
    func gridStyle() -> some View {
        modifier(Grid())
    }
}

struct Grid: ViewModifier {
    func body(content: Content) -> some View {
        content
            .listRowBackground(Color(.clear))
            .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 0))
            .listRowSeparator(.hidden)
    }
}

extension String: Identifiable {
    public typealias ID = Int
    public var id: Int {
        return hash
    }
}

extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}

extension Color {
    func convertedToCGFloat() -> [CGFloat] {
        return UIColor(self).cgColor.components ?? [1, 0.41, 0.38, 1]
    }
}

