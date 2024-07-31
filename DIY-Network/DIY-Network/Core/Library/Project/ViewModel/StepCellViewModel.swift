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
  @Published var isCompleted: Bool

  init(step: ProjectStepModel) {
    self.step = step
    self.isCompleted = step.isCompleted
  }
  
  func toggleComplete() {
    isCompleted.toggle()
    Task {
      do {
        try await LibraryService.handleCompletion(step: self.step)
      } catch {
        isCompleted.toggle()
        print(
          "DEBUG: Failed to toggle completion for step \(step.id) with error \(error.localizedDescription)"
        )
      }
    }
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
        stepDesc: "Please refresh the page",
        isCompleted: false
      )
      print("DEBUG: Step data couldn't fetched with error: \(error.localizedDescription)")
    }
  }
}
