//
//  StepCellViewModel.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 29.07.24.
//

import Foundation

@MainActor
class StepCellViewModel: ObservableObject {
  @Published var step: ProjectStepModel

  init(step: ProjectStepModel) {
    self.step = step
  }

  func getStep() async throws {
    do {
      step.self = try await LibraryService.fetchSingleStepData(step: step)
    } catch {
      self.step = ProjectStepModel(
        id: "0000",
        projectId: "0000",
        stepNumber: 0000,
        stepName: "Deleted Step",
        stepDesc: "Please refresh the page"
      )
      print("DEBUG: Step data couldn't fetched with error: \(error.localizedDescription)")
    }
  }
}
