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

  @Published var selectedImages: [PhotosPickerItem] = [] {
    didSet { Task { await loadImages(fromItems: selectedImages) } }
  }
  @Published var stepImages: [Image] = []
  private var uiImages: [UIImage] = []

  init(project: ProjectModel) {
    self.project = project
  }

  func createNewStep() async throws {
    guard let stepNumber = Int(number) else {
      print("DEBUG: There is no step number!")
      return
    }

    if !name.isEmpty && !desc.isEmpty {
      if !uiImages.isEmpty {
        print("DEBUG: Conditions are checked. Creating the step with images...")
        let imageUrls = try await ImageUploader.uploadImages(withData: uiImages)

        await LibraryService.uploadProjectStepData(
          project: project,
          stepNumber: stepNumber,
          stepName: name,
          stepDesc: desc,
          imageUrls: imageUrls
        )
        print("DEBUG: Step with images is created!")
      } else {
        print("DEBUG: Conditions are checked. Creating the step...")
        await LibraryService.uploadProjectStepData(
          project: project,
          stepNumber: stepNumber,
          stepName: name,
          stepDesc: desc,
          imageUrls: []
        )
        print("DEBUG: Step is created!")
      }
    } else {
      print("DEBUG: There is no step name or description!")
    }
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
