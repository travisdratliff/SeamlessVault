//
//  ArtistsView.swift
//  SV3
//
//  Created by Travis Domenic Ratliff on 3/11/24.
//

import SwiftUI
import SwiftData
import Observation

struct ArtistsView: View {
    @Query var patterns: [Pattern]
    @State private var showAddPattern = false
    @State private var showSheet = false
    @State private var showSearchSheet = false
    @State private var showPickedSheet: String? = nil
    private var artistArray: [String] {
        var array = [String]()
        for i in patterns {
            array.append(i.artist)
        }
        return array.uniqued()
    }
    var logoColor: LogoColor
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(artistArray.sorted(), id: \.self) { artist in
                        HStack {
                            Text(artist)
                            Spacer()
                            Button {
                                showPickedSheet = artist
                            } label: {
                                Image(systemName: "chevron.up")
                            }
                        }
                    }
                    .sheet(item: $showPickedSheet) { artist in
                        PickedArtistView(artist: artist)
                    }
                } header: {
                    Text("Artists")
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
    ArtistsView(logoColor: LogoColor())
        .modelContainer(for: Pattern.self)
}
