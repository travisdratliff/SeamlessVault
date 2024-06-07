//
//  TagsView.swift
//  SV3
//
//  Created by Travis Domenic Ratliff on 3/16/24.
//

import SwiftUI
import SwiftData
import Observation

struct TagsView: View {
    @Query var patterns: [Pattern]
    @State private var showAddPattern = false
    @State private var showSheet = false
    @State private var showSearchSheet = false
    @State private var showPickedSheet: String? = nil
    @State private var tagSet = Set<String>()
    private var tagsArray: [String] {
        var array = [String]()
        for i in patterns {
            for j in i.tags {
                array.append(j)
            }
        }
        return array.uniqued()
    }
    var logoColor: LogoColor
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(tagsArray.sorted()) { tag in
                        HStack {
                            Text(tag)
                            Spacer()
                            Button {
                                showPickedSheet = tag
                            } label: {
                                Image(systemName: "chevron.up")
                            }
                        }
                        .sheet(item: $showPickedSheet) { tag in
                            PickedTagView(tag: tag)
                        }
                    }
                } header: {
                    Text("Tags")
                }
            }
            .listRowBackground(Color(red: 0.9, green: 0.97, blue: 0.9))
            .shadow(color: .black, radius: 0.5, x: 5, y: 5)
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
    TagsView(logoColor: LogoColor())
        .modelContainer(for: [Pattern.self])
}

