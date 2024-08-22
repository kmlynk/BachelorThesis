//
//  CreateProjectViewModel.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 19.06.24.
//

import Firebase
import Foundation
import PhotosUI
import SwiftUI

@MainActor
class CreateProjectViewModel: ObservableObject {
  private let user: UserModel
  @Published var projectName = ""
  @Published var projectDesc = ""
  @Published var ytLink = ""

  @Published var selectedImage: PhotosPickerItem? {
    didSet { Task { await loadImage(fromItem: selectedImage) } }
  }
  @Published var projectImage: Image?
  private var uiImage: UIImage?

  @Published var selectedVideo: PhotosPickerItem? {
    didSet { Task { try await loadVideo(fromItem: selectedVideo) } }
  }
  @Published var projectVideoData: Data?

  init(user: UserModel) {
    self.user = user
  }

  func createNewProject() async throws -> String? {
    if projectName == "" || projectDesc == "" {
      return "Please fill in Project Name and Project Description"
    }

    var image = ""
    var video = ""

    if let uiImage = uiImage {
      guard let imageUrl = try await ImageUploader.uploadImage(withData: uiImage) else {
        return "Unable to upload image"
      }
      image = imageUrl
    }

    if let videoData = projectVideoData {
      guard let videoUrl = try await VideoUploader.uploadVideo(withData: videoData) else {
        return "Unable to upload video"
      }
      video = videoUrl
    }

    await LibraryService.uploadProjectData(
      ownerId: user.id,
      projectName: projectName,
      projectDesc: projectDesc,
      imageUrl: image,
      videoUrl: video,
      ytVideoUrl: ytLink
    )

    return ""
  }

  func loadImage(fromItem item: PhotosPickerItem?) async {
    guard let item = item else { return }
    guard let data = try? await item.loadTransferable(type: Data.self) else { return }

    print("DEBUG: Image data is \(data)")

    guard let uiImage = UIImage(data: data) else { return }
    self.uiImage = uiImage
    self.projectImage = Image(uiImage: uiImage)
  }

  func loadVideo(fromItem item: PhotosPickerItem?) async throws {
    guard let item = item else { return }
    guard let videoData = try? await item.loadTransferable(type: Data.self) else { return }

    print("DEBUG: Video data is \(videoData)")
    self.projectVideoData = videoData
  }
}
