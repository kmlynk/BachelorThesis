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

  @Published var stepName = ""
  @Published var stepDesc = ""

  init(user: UserModel, project: ProjectModel) {
    self.user = user
    self.project = project
  }
}
