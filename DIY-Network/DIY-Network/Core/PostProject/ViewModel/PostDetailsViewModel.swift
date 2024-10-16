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
  @Published var label1 = ""
  @Published var label2 = ""
  @Published var label3 = ""
  @Published var error = ""

  private var uiImage: UIImage?

  init(project: ProjectModel) {
    self.project = project

    self.name = project.projectName
  }

  func createPost() async throws {
    error = ""
    
    guard !label1.trimmingCharacters(in: .whitespaces).isEmpty else {
      error = "Label is required."
      return
    }
    
    var labels = [label1]
    if label2 != "" {
      labels.append(label2)
    }
    if label3 != "" {
      labels.append(label3)
    }

    if let uiImage = uiImage {
      guard let imageUrl = try await ImageUploader.uploadImage(withData: uiImage) else { return }

      try await PostService.uploadPostData(
        ownerId: project.ownerId,
        projectId: project.id,
        imageUrl: imageUrl,
        caption: caption,
        labels: labels
      )
    } else {
      guard project.projectImageUrl != "" else {
        error = "An image is required."
        return
      }
      
      try await PostService.uploadPostData(
        ownerId: project.ownerId,
        projectId: project.id,
        imageUrl: project.projectImageUrl!,
        caption: caption,
        labels: labels
      )
    }
  }

  func loadImage(fromItem item: PhotosPickerItem?) async {
    guard let item = item else { return }
    guard let data = try? await item.loadTransferable(type: Data.self) else { return }

    guard let uiImage = UIImage(data: data) else { return }
    self.uiImage = uiImage
    self.postImage = Image(uiImage: uiImage)
  }
}
