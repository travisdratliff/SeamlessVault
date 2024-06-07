//
//  ContentView.swift
//  SV3
//
//  Created by Travis Domenic Ratliff on 3/6/24.
//

import SwiftUI
import SwiftData 
import Observation

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var colorMode = ColorMode()
    @State private var logoColor = LogoColor()
    var body: some View {
        TabView {
            SeamlessView(logoColor: logoColor)
                .tabItem {
                    Label {
                        Text("SEAMLESS")
                    } icon: {
                        Image(systemName: "squareshape.split.2x2.dotted")
                    }
                    .environment(\.symbolVariants, .none)
                }
            PNGView(logoColor: logoColor)
                .tabItem {
                    Label {
                        Text("PNG")
                    } icon: {
                        Image(systemName: "squareshape")
                    }
                    .environment(\.symbolVariants, .none)
                }
            ArtistsView(logoColor: logoColor)
                .tabItem {
                    Label {
                        Text("ARTISTS")
                    } icon: {
                        Image(systemName: "paintbrush.pointed")
                    }
                    .environment(\.symbolVariants, .none)
                }
            TagsView(logoColor: logoColor)
                .tabItem {
                    Label {
                        Text("TAGS")
                    } icon: {
                        Image(systemName: "tag")
                    }
                    .environment(\.symbolVariants, .none)
                }
            SettingsView(colorMode: colorMode, logoColor: logoColor)
                .tabItem {
                    Label {
                        Text("SETTINGS")
                    } icon: {
                        Image(systemName: "gearshape")
                    }
                    .environment(\.symbolVariants, .none)
                }
        }
        .accentColor(.primary)
        .preferredColorScheme(colorMode.lightMode ? .dark : .light)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Pattern.self)
}
