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

    Task { try await fetchProjectSteps() }
  }

  func fetchProjectSteps() async throws {
    self.steps = try await LibraryService.fetchProjectStepData(project: project)
    if steps.count > 1 {
      sortSteps()
    } else {
      self.sortedSteps = self.steps
    }
  }

  func sortSteps() {
    guard steps.count > 1 else { return }
    let left = Array(steps[0..<steps.count / 2])
    let right = Array(steps[steps.count / 2..<steps.count])
    self.sortedSteps = mergeArray(left: left, right: right)
    for i in 0..<sortedSteps.count {
      print(
        "DEBUG: Step Number: \(sortedSteps[i].stepNumber) - Step Name: \(sortedSteps[i].stepName) - Step Description: \(sortedSteps[i].stepDesc)"
      )
    }
  }

  func mergeArray(left: [ProjectStepModel], right: [ProjectStepModel]) -> [ProjectStepModel] {
    var mergedArray: [ProjectStepModel] = []
    var left = left
    var right = right
    while left.count > 0 && right.count != 0 {
      if left.first!.stepNumber < right.first!.stepNumber {
        mergedArray.append(left.removeFirst())
      } else {
        mergedArray.append(right.removeFirst())
      }
    }
    return mergedArray + left + right
  }
}
