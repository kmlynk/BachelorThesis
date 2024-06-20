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

  init(project: ProjectModel) {
    self.project = project

    Task { try await fetchProjectSteps() }
  }

  func fetchProjectSteps() async throws {
    self.steps = try await LibraryService.fetchProjectStepData(project: project)
    print("DEBUG: \(self.steps)")
  }
}
