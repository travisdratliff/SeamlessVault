//
//  Pattern.swift
//  SV3
//
//  Created by Travis Domenic Ratliff on 3/11/24.
//

import Foundation
import SwiftData

@Model
class Pattern: Hashable {
    var title: String
    var type: String
    var artist: String
    var tags: [String]
    @Attribute(.externalStorage) var image: Data?
    var searchTags: [String] {
        [title, artist] + tags
    }
    init(title: String, type: String, artist: String, tags: [String], image: Data? = nil) {
        self.title = title
        self.type = type
        self.artist = artist
        self.tags = tags
        self.image = image
    }
}
