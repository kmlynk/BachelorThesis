//
//  AddProjectStepViewModel.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 20.06.24.
//

import Foundation

@MainActor
class AddProjectStepViewModel: ObservableObject {
  private let user: UserModel
  private var project: ProjectModel
  @Published var steps = [ProjectStepModel]()

  @Published var number = ""
  @Published var name = ""
  @Published var desc = ""

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
      print("DEBUG: Conditions are checked. Creating the step...")
      await LibraryService.uploadProjectStepData(
        project: project,
        stepNumber: stepNumber,
        stepName: name,
        stepDesc: desc
      )
      print("DEBUG: Step is created!")
    } else {
      print("DEBUG: There is no step name or description!")
    }
  }
}
