//
//  PostProjectViewModel.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 13.06.24.
//

import Firebase
import FirebaseFirestoreSwift
import Foundation
import PhotosUI
import SwiftUI

@MainActor
class PostProjectViewModel: ObservableObject {
  @Published var images = [ImageModel]()
  @Published var selectedItem: PhotosPickerItem? {
    didSet { Task { try await uploadImage() } }
  }

  init() {
    Task { try await fetchImages() }
  }

  func uploadImage() async throws {
    guard let item = selectedItem else { return }

    guard let imageData = try await item.loadTransferable(type: Data.self) else { return }

    print("DEBUG: Image data is \(imageData)")

    guard let uiImage = UIImage(data: imageData) else { return }

    guard let imageUrl = try await ImageUploader.uploadImage(withData: uiImage) else { return }

    try await Firestore.firestore().collection("images").document().setData(["imageUrl": imageUrl])

    print("DEBUG: Finished Image Upload!")
  }

  func fetchImages() async throws {
    let snapshot = try await Firestore.firestore().collection("images").getDocuments()

    self.images = snapshot.documents.compactMap({ try? $0.data(as: ImageModel.self) })
  }
}
