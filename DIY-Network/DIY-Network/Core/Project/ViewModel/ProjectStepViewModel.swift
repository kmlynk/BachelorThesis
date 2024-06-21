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
      self.sortedSteps = mergeSort(arr: steps)
    } else {
      self.sortedSteps = self.steps
    }
  }

  func mergeSort(arr: [ProjectStepModel]) -> [ProjectStepModel] {
    guard arr.count > 1 else { return arr }

    let leftArr = Array(arr[0..<arr.count / 2])
    let rightArr = Array(arr[arr.count / 2..<arr.count])

    return merge(left: mergeSort(arr: leftArr), right: mergeSort(arr: rightArr))
  }

  func merge(left: [ProjectStepModel], right: [ProjectStepModel]) -> [ProjectStepModel] {
    var mergedArr = [ProjectStepModel]()
    var left = left
    var right = right

    while left.count > 0 && right.count > 0 {
      if left.first!.stepNumber < right.first!.stepNumber {
        mergedArr.append(left.removeFirst())
      } else {
        mergedArr.append(right.removeFirst())
      }
    }

    return mergedArr + left + right
  }
}
