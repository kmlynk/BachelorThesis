//
//  EditStepViewModel.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 24.06.24.
//

import Foundation
import PhotosUI
import SwiftUI

@MainActor
class EditStepViewModel: ObservableObject {
  @Published var step: ProjectStepModel
  @Published var selectedImages: [PhotosPickerItem] = [] {
    didSet { Task { await loadImages(fromItems: selectedImages) } }
  }
  @Published var stepImages: [Image] = []
  @Published var number = ""
  @Published var name = ""
  @Published var desc = ""
  @Published var error = ""

  private var uiImages: [UIImage] = []

  init(step: ProjectStepModel) {
    self.step = step
    self.number = String(step.stepNumber)
    self.name = step.stepName
    self.desc = step.stepDesc

    if let imageUrls = step.stepImageUrls {
      self.stepImages = imageUrls.compactMap { urlString in
        if let url = URL(string: urlString),
          let data = try? Data(contentsOf: url),
          let uiImage = UIImage(data: data)
        {
          return Image(uiImage: uiImage)
        }
        return nil
      }
    }
  }

  func updateStep() async throws {
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

    var uploadedImageUrls: [String] = []
    for uiImage in uiImages {
      if let imageUrl = try await ImageUploader.uploadImage(withData: uiImage) {
        uploadedImageUrls.append(imageUrl)
      }
    }

    if uploadedImageUrls.isEmpty, let existingUrls = step.stepImageUrls {
      uploadedImageUrls = existingUrls
    }

    try await LibraryService.updateStepData(
      step: step,
      imageUrls: uploadedImageUrls,
      number: stepNumber,
      name: name,
      desc: desc
    )
  }

  func loadImages(fromItems items: [PhotosPickerItem]) async {
    uiImages.removeAll()
    stepImages.removeAll()

    for item in items {
      guard let data = try? await item.loadTransferable(type: Data.self),
        let uiImage = UIImage(data: data)
      else { continue }

      uiImages.append(uiImage)
      stepImages.append(Image(uiImage: uiImage))
    }
  }
}
