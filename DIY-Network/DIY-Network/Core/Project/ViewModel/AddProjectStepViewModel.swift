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
  private let user: UserModel
  private var project: ProjectModel
  @Published var steps = [ProjectStepModel]()

  @Published var number = ""
  @Published var name = ""
  @Published var desc = ""

  @Published var selectedImage: PhotosPickerItem? {
    didSet { Task { await loadImage(fromItem: selectedImage) } }
  }
  @Published var stepImage: Image?
  private var uiImage: UIImage?

  init(user: UserModel, project: ProjectModel) {
    self.user = user
    self.project = project
  }

  func createNewStep() async throws {
    guard let stepNumber = Int(number) else {
      print("DEBUG: There is no step number!")
      return
    }

    if !name.isEmpty && !desc.isEmpty {
      if let uiImage = uiImage {
        print("DEBUG: Conditions are checked. Creating the step with image...")
        guard let imageUrl = try await ImageUploader.uploadImage(withData: uiImage) else { return }

        await LibraryService.uploadProjectStepData(
          withImage: imageUrl,
          project: project,
          stepNumber: stepNumber,
          stepName: name,
          stepDesc: desc
        )
        print("DEBUG: Step with image is created!")
      } else {
        print("DEBUG: Conditions are checked. Creating the step...")
        await LibraryService.uploadProjectStepData(
          project: project,
          stepNumber: stepNumber,
          stepName: name,
          stepDesc: desc
        )
        print("DEBUG: Step is created!")
      }
    } else {
      print("DEBUG: There is no step name or description!")
    }
  }

  func loadImage(fromItem item: PhotosPickerItem?) async {
    guard let item = item else { return }
    guard let data = try? await item.loadTransferable(type: Data.self) else { return }

    print("DEBUG: Image data is \(data)")

    guard let uiImage = UIImage(data: data) else { return }
    self.uiImage = uiImage
    self.stepImage = Image(uiImage: uiImage)
  }
}
