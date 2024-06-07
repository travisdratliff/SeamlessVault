//
//  EditPatternView.swift
//  SV3
//
//  Created by Travis Domenic Ratliff on 3/30/24.
//

import SwiftUI
import Combine
import SwiftData
import Observation

struct EditPatternView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    @Bindable var pattern: Pattern
    @State var newTitle = ""
    @State var newArtist = ""
    @State var newType = "Seamless"
    @State private var tagInput = ""
    @State private var newTagArray = [String]()
    private var tagInputIsValid: Bool {
        !tagInput.isReallyEmpty
    }
    private var onlyOneTag: Bool {
        newTagArray.count < 2
    }
    let types = ["Seamless", "PNG"]
    @State var publisher = PassthroughSubject<String, Never>()
    var valueChanged: ((_ value: String) -> Void)?
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Edit Title", text: $newTitle)
                        .onChange(of: newTitle) {
                            publisher.send(newTitle)
                        }
                        .onReceive(publisher.debounce(for: .seconds(1), scheduler: DispatchQueue.main)) { value in
                            if let valueChanged {
                                valueChanged(value)
                            }
                        }
                    TextField("Edit Artist", text: $newArtist)
                        .onChange(of: newArtist) {
                            publisher.send(newArtist)
                        }
                        .onReceive(publisher.debounce(for: .seconds(1), scheduler: DispatchQueue.main)) { value in
                            if let valueChanged {
                                valueChanged(value)
                            }
                        }
                    
                    Picker("Type", selection: $newType) {
                        ForEach(types, id: \.self) { type in
                            Text(type)
                        }
                    }
                    .pickerStyle(.segmented)
                } footer: {
                    Text("Changing some details of \(pattern.title) may dismiss its detail page. You can find \(pattern.title) again under its new type, artist, or tag, or by using \(Image(systemName: "magnifyingglass")) Search. More info in \(Image(systemName: "gearshape")) Settings.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                Section {
                    HStack {
                        TextField("Tags, separated by commas", text: $tagInput)
                            .onChange(of: tagInput) {
                                publisher.send(tagInput)
                            }
                            .onReceive(publisher.debounce(for: .seconds(1), scheduler: DispatchQueue.main)) { value in
                                if let valueChanged {
                                    valueChanged(value)
                                }
                            }
                        Spacer()
                        Button {
                            for i in tagInput.components(separatedBy: ",") {
                                newTagArray.append(i.trimmingCharacters(in: .whitespacesAndNewlines).capitalized)
                            }
                            tagInput = ""
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(tagInputIsValid ? .primary : .secondary)
                        }
                        .disabled(!tagInputIsValid)
                    }
                    ForEach(newTagArray, id: \.self) { tag in
                        HStack {
                            Button {
                                if let index = newTagArray.firstIndex(of: tag) {
                                    newTagArray.remove(at: index)
                                }
                            } label: {
                                Image(systemName: "xmark")
                                    .foregroundColor(onlyOneTag ? .secondary : .primary)
                            }
                            .disabled(onlyOneTag)
                            Text(tag)
                        }
                    }
                }
            }
            .navigationTitle("Edit \(pattern.title)")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if !newTitle.isReallyEmpty {
                            pattern.title = newTitle.trimmingCharacters(in: .whitespacesAndNewlines).capitalized
                        }
                        if !newArtist.isReallyEmpty {
                            pattern.artist = newArtist.trimmingCharacters(in: .whitespacesAndNewlines).capitalized
                        }
                        pattern.type = newType
                        pattern.tags = newTagArray
                        do {
                            try context.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                            .foregroundColor(.primary)
                    }
                }
            }
            .onAppear {
                newTagArray = pattern.tags
                newType = pattern.type
            }
            .interactiveDismissDisabled()
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Pattern.self, configurations: config)
        let patternExample = Pattern(title: "Pikachu", type: "PNG", artist: "Courtney", tags: ["Floral"], image: nil)
        return EditPatternView(pattern: patternExample)
            .modelContainer(container)
    } catch {
        fatalError()
    }
}
