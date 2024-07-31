//
//  CreateProjectViewModel.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 19.06.24.
//

import Foundation
import PhotosUI
import SwiftUI

@MainActor
class CreateProjectViewModel: ObservableObject {
  private let user: UserModel
  @Published var projectName = ""
  @Published var projectDesc = ""

  @Published var selectedImage: PhotosPickerItem? {
    didSet { Task { await loadImage(fromItem: selectedImage) } }
  }
  @Published var projectImage: Image?
  private var uiImage: UIImage?

  init(user: UserModel) {
    self.user = user
  }

  func createNewProject() async throws {
    if let uiImage = uiImage {
      guard let imageUrl = try await ImageUploader.uploadImage(withData: uiImage) else { return }

      await LibraryService.uploadProjectData(
        ownerId: user.id,
        projectName: projectName,
        projectDesc: projectDesc,
        imageUrl: imageUrl
      )
    } else {
      await LibraryService.uploadProjectData(
        ownerId: user.id,
        projectName: projectName,
        projectDesc: projectDesc,
        imageUrl: nil
      )
    }
  }

  func loadImage(fromItem item: PhotosPickerItem?) async {
    guard let item = item else { return }
    guard let data = try? await item.loadTransferable(type: Data.self) else { return }

    print("DEBUG: Image data is \(data)")

    guard let uiImage = UIImage(data: data) else { return }
    self.uiImage = uiImage
    self.projectImage = Image(uiImage: uiImage)
  }
}
