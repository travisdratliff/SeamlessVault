//
//  PatternDetailView.swift
//  SV3
//
//  Created by Travis Domenic Ratliff on 3/11/24.
//

import SwiftUI
import SwiftData
import Observation
import Combine

struct PatternDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    var pattern: Pattern
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showEdit = false
    let types = ["Seamless", "PNG"]
    @State var publisher = PassthroughSubject<String, Never>()
    var valueChanged: ((_ value: String) -> Void)?
    var body: some View {
        NavigationStack {
            List {
                Section {
                    if let image = pattern.image,
                       let uiImage = UIImage(data: image) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .cornerRadius(10)
                    }
                }
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowBackground(Color(.white))
                Section {
                    Label(pattern.title, systemImage: "lanyardcard")
                        .foregroundColor(.primary)
                    Label(pattern.artist, systemImage: "paintbrush.pointed")
                        .foregroundColor(.primary)
                    Label(pattern.type, systemImage: pattern.type == "Seamless" ? "squareshape.split.2x2.dotted" : "squareshape")
                        .foregroundColor(.primary)
                }
                Section {
                   ForEach(pattern.tags.sorted(), id: \.self) {
                        Label($0, systemImage: "tag")
                            .foregroundColor(.primary)
                    }
                }
            }
            .shadow(color: .black, radius: 0.5, x: 5, y: 5)
            .navigationTitle(pattern.title)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showAlert.toggle()
                        alertMessage = "Are you sure you want to delete this pattern?"
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showEdit.toggle()
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.primary)
                    }
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
            .alert(alertMessage, isPresented: $showAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete \(pattern.title)", role: .destructive) {
                    context.delete(pattern)
                    do {
                        try context.save()
                    } catch {
                        fatalError()
                    }
                    dismiss()
                }
            }
            .sheet(isPresented: $showEdit) {
                EditPatternView(pattern: pattern)
                    .presentationDetents([.medium])
            }
            .onChange(of: pattern.type) {
                dismiss()
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Pattern.self, configurations: config)
        let patternExample = Pattern(title: "Pikachu", type: "PNG", artist: "Courtney", tags: ["Floral"], image: nil)
        return PatternDetailView(pattern: patternExample)
            .modelContainer(container)
    } catch {
        fatalError()
    }
}

