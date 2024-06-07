//
//  SearchView.swift
//  SV3
//
//  Created by Travis Domenic Ratliff on 3/20/24.
//

import SwiftUI
import SwiftData
import Observation

struct SearchView: View {
    @Environment(\.dismiss) var dismiss
    @Query(sort: \Pattern.title) var patterns: [Pattern]
    @State private var showSheet = false
    @State private var showDetailSheet: Pattern? = nil
    @State private var searchText = ""
    let types = ["All", "Seamless", "PNG"]
    @State private var pickedType = "All"
    let columns = [
        GridItem(.adaptive(minimum: 160))
    ]
    var filteredPatterns: [Pattern] {
        if searchText.isReallyEmpty {
            return patterns
        }
        return patterns.filter { pattern in
            pattern.searchTags.filterTags(text: searchText)
        }
    }
    var body: some View {
        NavigationStack {
            List {
                ScrollView {
                    LazyVGrid(columns: columns, alignment: .center, spacing: 15) {
                        ForEach(filteredPatterns) { pattern in
                            if pattern.type == pickedType || pickedType == "All" {
                                VStack {
                                    Button {
                                        showDetailSheet = pattern
                                    } label: {
                                        if let image = pattern.image,
                                           let uiImage = UIImage(data: image) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFill()
                                                .background(Color(.white))
                                        }
                                    }
                                    .frame(width: 150, height: 150, alignment: .center)
                                    .cornerRadius(10)
                                    Text(pattern.title)
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .sheet(item: $showDetailSheet) { pattern in
                            PatternDetailView(pattern: pattern)
                        }
                    }
                }
                .gridStyle()
            }
            .navigationTitle("Search")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Picker("Type", selection: $pickedType) {
                        ForEach(types, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search title, artist, or tag")
    }
}

#Preview {
    SearchView()
        .modelContainer(for: Pattern.self)
}
