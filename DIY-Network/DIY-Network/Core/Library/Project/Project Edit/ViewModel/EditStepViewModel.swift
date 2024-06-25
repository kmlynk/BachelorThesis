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
  @Published var selectedImage: PhotosPickerItem? {
    didSet { Task { await loadImage(fromItem: selectedImage) } }
  }
  @Published var stepImage: Image?
  @Published var number = ""
  @Published var name = ""
  @Published var desc = ""

  private var uiImage: UIImage?

  init(step: ProjectStepModel) {
    self.step = step

    self.number = String(step.stepNumber)
    self.name = step.stepName
    self.desc = step.stepDesc
  }

  func loadImage(fromItem item: PhotosPickerItem?) async {
    guard let item = item else { return }
    guard let data = try? await item.loadTransferable(type: Data.self) else { return }
    print("DEBUG: Image data is \(data)")

    guard let uiImage = UIImage(data: data) else { return }
    self.uiImage = uiImage
    self.stepImage = Image(uiImage: uiImage)
  }

  func updateStep() async throws {
    guard let stepNumber = Int(number) else {
      print("DEBUG: There is no step number!")
      return
    }

    try await LibraryService.updateStepData(
      step: step, uiImage: uiImage, number: stepNumber, name: name, desc: desc)
  }
}
