//
//  PNGView.swift
//  SV3
//
//  Created by Travis Domenic Ratliff on 3/11/24.
//

import SwiftUI
import SwiftData
import Observation

struct PNGView: View {
    @State var showAddPattern = false
    @Query(sort: \Pattern.title) var patterns: [Pattern]
    @State private var showDetailSheet: Pattern? = nil
    @State private var showSearchSheet = false
    let columns = [
        GridItem(.adaptive(minimum: 160))
    ]
    var logoColor: LogoColor
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ScrollView {
                        LazyVGrid(columns: columns, alignment: .center, spacing: 15) {
                            ForEach(patterns) { pattern in
                                if pattern.type == "PNG" {
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
                                        Spacer()
                                    }
                                }
                            }
                            .sheet(item: $showDetailSheet) { pattern in
                                PatternDetailView(pattern: pattern)
                            }
                        }
                    }
                    .gridStyle()
                } header: {
                    Text("PNG")
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Seamless Vault ")
                        .font(.custom("Pacifico-Regular", size: 30))
                        .foregroundColor(Color(red: logoColor.logoColor[0], green: logoColor.logoColor[1], blue: logoColor.logoColor[2]))
                        .opacity(logoColor.logoColor[3])
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        showSearchSheet.toggle()
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.primary)
                    }
                    Button {
                        showAddPattern.toggle()
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.primary)
                    }
                }
            }
            .sheet(isPresented: $showAddPattern) {
                AddPatternView()
            }
            .sheet(isPresented: $showSearchSheet) {
                SearchView()
            }
        }
    }
}

#Preview {
    PNGView(logoColor: LogoColor())
        .modelContainer(for: Pattern.self)
}
