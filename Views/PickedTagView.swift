//
//  PickedTagView.swift
//  SV3
//
//  Created by Travis Domenic Ratliff on 3/20/24.
//

import SwiftUI
import SwiftData

struct PickedTagView: View {
    @Environment(\.dismiss) var dismiss
    var tag: String
    @Query(sort: \Pattern.title) var patterns: [Pattern]
    @State private var showDetailSheet: Pattern? = nil
    @State private var showSearchSheet = false
    let columns = [
        GridItem(.adaptive(minimum: 160))
    ]
    let types = ["All", "Seamless", "PNG"]
    @State private var pickedType = "All"
    // write property where if there are no patterns with this tag, it will dismiss
    var body: some View {
        NavigationStack {
            List {
                ScrollView {
                    LazyVGrid(columns: columns, alignment: .center, spacing: 15) {
                        ForEach(patterns) { pattern in
                            if (pattern.tags.contains(tag) && pattern.type == pickedType) || (pattern.tags.contains(tag) && pickedType == "All") {
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
            .navigationTitle(tag)
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
        .onAppear {

        }
    }
}

#Preview {
    PickedTagView(tag: "Meh")
}
