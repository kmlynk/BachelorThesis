//
//  EditProjectViewModel.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 23.06.24.
//

import Foundation
import PhotosUI
import SwiftUI

@MainActor
class EditProjectViewModel: ObservableObject {
  @Published var project: ProjectModel
  @Published var selectedImage: PhotosPickerItem? {
    didSet { Task { await loadImage(fromItem: selectedImage) } }
  }
  @Published var projectImage: Image?
  @Published var name = ""
  @Published var desc = ""
  @Published var error = ""

  private var uiImage: UIImage?

  init(project: ProjectModel) {
    self.project = project

    self.name = project.projectName
    self.desc = project.projectDesc
  }

  func updateProject() async throws {
    error = ""

    guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
      error = "Project name is required."
      return
    }

    guard !desc.trimmingCharacters(in: .whitespaces).isEmpty else {
      error = "Project description is required."
      return
    }

    try await LibraryService.updateProjectData(
      project: project, uiImage: uiImage, name: name, desc: desc)
  }

  func loadImage(fromItem item: PhotosPickerItem?) async {
    guard let item = item else { return }
    guard let data = try? await item.loadTransferable(type: Data.self) else { return }

    guard let uiImage = UIImage(data: data) else { return }
    self.uiImage = uiImage
    self.projectImage = Image(uiImage: uiImage)
  }
}
