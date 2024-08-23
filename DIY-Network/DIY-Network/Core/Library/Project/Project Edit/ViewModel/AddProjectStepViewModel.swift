//
//  AddProjectStepViewModel.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 20.06.24.
//

import Foundation
import PhotosUI
import SwiftUI

@MainActor
class AddProjectStepViewModel: ObservableObject {
  private var project: ProjectModel
  @Published var steps = [ProjectStepModel]()

  @Published var number = ""
  @Published var name = ""
  @Published var desc = ""
  @Published var error = ""

  @Published var selectedImages: [PhotosPickerItem] = [] {
    didSet { Task { await loadImages(fromItems: selectedImages) } }
  }
  @Published var stepImages: [Image] = []
  private var uiImages: [UIImage] = []

  init(project: ProjectModel) {
    self.project = project
  }

  func createNewStep() async throws {
    error = ""

    guard !number.trimmingCharacters(in: .whitespaces).isEmpty, let stepNumber = Int(number) else {
      error = "Step number is required and must be a valid number."
      return
    }

    guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
      error = "Step name is required."
      return
    }

    guard !desc.trimmingCharacters(in: .whitespaces).isEmpty else {
      error = "Step description is required."
      return
    }

    var imageUrls = [String]()
    if !uiImages.isEmpty {
      imageUrls = try await ImageUploader.uploadImages(withData: uiImages)
    }

    await LibraryService.uploadProjectStepData(
      project: project,
      stepNumber: stepNumber,
      stepName: name,
      stepDesc: desc,
      imageUrls: imageUrls
    )
  }

  func loadImages(fromItems items: [PhotosPickerItem]) async {
    uiImages = []
    stepImages = []

    for item in items {
      guard let data = try? await item.loadTransferable(type: Data.self) else { continue }

      print("DEBUG: Image data is \(data)")

      if let uiImage = UIImage(data: data) {
        uiImages.append(uiImage)
        stepImages.append(Image(uiImage: uiImage))
      }
    }
  }
}
