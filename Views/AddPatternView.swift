//
//  AddPatternView.swift
//  SV3
//
//  Created by Travis Domenic Ratliff on 3/11/24.
//

import SwiftUI
import PhotosUI
import SwiftData
import Observation
import Combine

struct AddPatternView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var context
    @State private var title = ""
    @State private var type = "Seamless"
    @State private var artistName = ""
    @State private var tagInput = ""
    @State private var searchTags = [String]()
    @State private var tagArray = [String]()
    @State private var selectedImage: PhotosPickerItem?
    @State private var selectedImageData: Data?
    private var types = ["Seamless", "PNG"]
    private var isValid: Bool {
        !title.isReallyEmpty && !artistName.isReallyEmpty && !tagArray.isEmpty && selectedImageData != nil
    }
    private var tagInputIsValid: Bool {
        !tagInput.isReallyEmpty
    }
    @State var publisher = PassthroughSubject<String, Never>()
    var valueChanged: ((_ value: String) -> Void)?
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $title)
                        .onChange(of: title) {
                            publisher.send(title)
                        }
                        .onReceive(publisher.debounce(for: .seconds(1), scheduler: DispatchQueue.main)) { value in
                            if let valueChanged {
                                valueChanged(value)
                            }
                        }
                    TextField("Artist", text: $artistName)
                        .onChange(of: artistName) {
                            publisher.send(artistName)
                        }
                        .onReceive(publisher.debounce(for: .seconds(1), scheduler: DispatchQueue.main)) { value in
                            if let valueChanged {
                                valueChanged(value)
                            }
                        }
                    Picker("Type", selection: $type) {
                        ForEach(types, id: \.self) { type in
                            Text(type)
                        }
                    }
                    .pickerStyle(.segmented)
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
                                tagArray.append(i.trimmingCharacters(in: .whitespacesAndNewlines).capitalized)
                            }
                            tagInput = ""
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(tagInputIsValid ? .primary : .secondary)
                        }
                        .disabled(!tagInputIsValid)
                    }
                    ForEach(tagArray, id: \.self) { tag in
                        HStack {
                            Button {
                                if let index = tagArray.firstIndex(of: tag) {
                                    tagArray.remove(at: index)
                                }
                            } label: {
                                Image(systemName: "xmark")
                                    .foregroundColor(.primary)
                            }
                            Text(tag)
                        }
                    }
                }
                Section {
                    PhotosPicker(selection: $selectedImage,
                                 matching: .images,
                                 photoLibrary: .shared()) {
                        Label(selectedImageData != nil ? "Change photo" : "Choose photo", systemImage: "photo")
                            .foregroundColor(.primary)
                    }
                    if let selectedImageData,
                        let uiImage = UIImage(data: selectedImageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .background(Color(.white))
                                .cornerRadius(10)
                                .listRowSeparator(.hidden)
                                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                        }
                  
                }
            }
            .shadow(color: .black, radius: 0.5, x: 5, y: 5)
            .navigationTitle("Add Pattern")
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
                        let pattern = Pattern(title: title.trimmingCharacters(in: .whitespacesAndNewlines).capitalized, type: type, artist: artistName.trimmingCharacters(in: .whitespacesAndNewlines).capitalized, tags: tagArray, image: selectedImageData)
                        context.insert(pattern)
                        do {
                            try context.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                        dismiss()
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(isValid ? .primary : .secondary)
                    }
                    .disabled(!isValid)
                }
            }
            .task(id: selectedImage) {
                if let data = try? await selectedImage?.loadTransferable(type: Data.self) {
                    if let image = UIImage(data: data) {
                        let jpegData = image.jpegData(compressionQuality: 0.2)
                        selectedImageData = jpegData
                    }
                }
            }
            .interactiveDismissDisabled()
        }
    }
}

#Preview {
    AddPatternView()
        .modelContainer(for: Pattern.self)
}
