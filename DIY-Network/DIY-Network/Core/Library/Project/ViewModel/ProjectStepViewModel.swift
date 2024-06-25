//
//  ProjectStepViewModel.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 20.06.24.
//

import Foundation

@MainActor
class ProjectStepViewModel: ObservableObject {
  private let project: ProjectModel
  @Published var steps = [ProjectStepModel]()
  @Published var sortedSteps = [ProjectStepModel]()

  init(project: ProjectModel) {
    self.project = project
  }

  func fetchProjectSteps() async throws {
    self.steps = try await LibraryService.fetchProjectStepData(project: project)
    if steps.count > 1 {
      self.sortedSteps = LibraryService.mergeSort(arr: steps)
    } else {
      self.sortedSteps = self.steps
    }
  }
}
