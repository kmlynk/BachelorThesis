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
  @Published var selectedVideo: PhotosPickerItem? {
    didSet { Task { try await loadVideo(fromItem: selectedVideo) } }
  }
  @Published var projectImage: Image?
  @Published var name = ""
  @Published var desc = ""
  @Published var ytLink = ""
  @Published var videoData: Data?
  @Published var docLink = ""
  @Published var selectedDocumentURL: URL?
  @Published var documentName = ""
  @Published var error = ""

  private var uiImage: UIImage?

  init(project: ProjectModel) {
    self.project = project

    self.name = project.projectName
    self.desc = project.projectDesc
    self.ytLink = project.ytVideoUrl ?? ""
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
      project: project, uiImage: uiImage, name: name, desc: desc, videoData: videoData,
      ytLink: ytLink, docURL: selectedDocumentURL)
  }

  func loadImage(fromItem item: PhotosPickerItem?) async {
    guard let item = item else { return }
    guard let data = try? await item.loadTransferable(type: Data.self) else { return }

    guard let uiImage = UIImage(data: data) else { return }
    self.uiImage = uiImage
    self.projectImage = Image(uiImage: uiImage)
  }

  func loadVideo(fromItem item: PhotosPickerItem?) async throws {
    guard let item = item else { return }
    guard let videoData = try? await item.loadTransferable(type: Data.self) else { return }

    print("DEBUG: Video data is \(videoData)")
    self.videoData = videoData
  }
}
