//
//  ProjectViewModel.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 29.07.24.
//

import Firebase
import Foundation

@MainActor
class ProjectViewModel: ObservableObject {
  let project: ProjectModel
  @Published var steps = [ProjectStepModel]()

  init(project: ProjectModel) {
    self.project = project
    Task { try await getProjectSteps() }
  }

  func getProjectSteps() async throws {
    do {
      self.steps = try await LibraryService.fetchProjectStepData(project: project)
      self.steps = LibraryService.mergeSort(arr: steps)
    } catch {
      print("DEBUG: Project's steps couldn't fetched with error: \(error.localizedDescription)")
    }
  }
}
