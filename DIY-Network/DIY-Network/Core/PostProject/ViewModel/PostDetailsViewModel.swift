//
//  PostDetailsViewModel.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 27.06.24.
//

import Foundation
import PhotosUI
import SwiftUI

@MainActor
class PostDetailsViewModel: ObservableObject {
  let project: ProjectModel
  @Published var selectedImage: PhotosPickerItem? {
    didSet { Task { await loadImage(fromItem: selectedImage) } }
  }
  @Published var postImage: Image?
  @Published var caption = ""
  @Published var name = ""

  private var uiImage: UIImage?

  init(project: ProjectModel) {
    self.project = project

    self.name = project.projectName
  }

  @MainActor
  func loadImage(fromItem item: PhotosPickerItem?) async {
    guard let item = item else { return }
    guard let data = try? await item.loadTransferable(type: Data.self) else { return }
    print("DEBUG: Image data is \(data)")

    guard let uiImage = UIImage(data: data) else { return }
    self.uiImage = uiImage
    self.postImage = Image(uiImage: uiImage)
  }

  func createPost() async throws {
    if let uiImage = uiImage {
      guard let imageUrl = try await ImageUploader.uploadImage(withData: uiImage) else { return }

      try await PostService.uploadPostData(
        ownerId: project.ownerId,
        projectId: project.id,
        imageUrl: imageUrl,
        caption: caption
      )
    } else {
      try await PostService.uploadPostData(
        ownerId: project.ownerId,
        projectId: project.id,
        imageUrl: project.projectImageUrl ?? "",
        caption: caption
      )
    }
  }
}
