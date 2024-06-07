//
//  SettingsView.swift
//  SV3
//
//  Created by Travis Domenic Ratliff on 3/23/24.
//

import SwiftUI
import SwiftData
import StoreKit

struct SettingsView: View {
    @Environment(\.requestReview) var requestReview
    @State var showAddPattern = false
    @State var showInfo = false
    @Query var patterns: [Pattern]
    @State private var showDetailSheet: Pattern? = nil
    @State private var showSearchSheet = false
    @Bindable var colorMode: ColorMode
    @Bindable var logoColor: LogoColor
    @State private var pickedColor = Color(red: 1.0, green: 0.41, blue: 0.38)
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle("Dark Mode", isOn: $colorMode.lightMode)
                    ColorPicker("Logo Color", selection: $pickedColor)
                        .onChange(of: pickedColor) {
                            logoColor.logoColor = pickedColor.convertedToCGFloat()
                        }
                } header: {
                    Text("Settings")
                }
                Section {
                    HStack {
                        Text("Rate The App")
                        Spacer()
                        Button {
                            requestReview()
                        } label: {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        }
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.capsule)
                        
                    }
                }
                Section {
                    HStack {
                        Text("Editing Info")
                        Spacer()
                        Button {
                            showInfo.toggle()
                        } label: {
                            Image(systemName: showInfo ? "xmark" : "chevron.down")
                        }
                    }
                    if showInfo {
                        Text("""
                         When you edit your patterns, sometimes the pattern's detail page that you are currently on will go away. This may happen for a couple of reasons:
                         
                         - When you delete or edit a tag or artist that is unique to that pattern. If you got to the pattern from the \(Image(systemName: "paintbrush.pointed")) Artists or \(Image(systemName: "tag")) Tags tab, and you edit the artist or tag, the old artist or tag will no longer exist. The detail page will drop back down and you will see a page with the old tag or artist title with no content. Tap \(Image(systemName: "xmark")) and the page will go away, and you will no longer see that artist or tag. You can find the pattern again in it's new artist or tag.
                         
                         - When you change the type. The pattern will be under the new type's tab once you tap \(Image(systemName: "checkmark")) to save the edit. You will find the pattern again in the new type.
                         
                         All patterns can be found again by searching for their details in \(Image(systemName: "magnifyingglass")) Search or by looking in their type's tab.
                         """ )
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Seamless Vault ")
                        .font(.custom("Pacifico-Regular", size: 30))
                        .foregroundColor(Color(red: logoColor.logoColor[0], green: logoColor.logoColor[1], blue: logoColor.logoColor[2]))
                        .opacity(logoColor.logoColor[3])
//                    original color: Color(red: 1.0, green: 0.41, blue: 0.38)
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
    SettingsView(colorMode: ColorMode(), logoColor: LogoColor())
        .modelContainer(for: Pattern.self)
}
