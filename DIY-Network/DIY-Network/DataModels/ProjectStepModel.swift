//
//  ProjectStepModel.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 16.06.24.
//

import Foundation

struct ProjectStepModel: Identifiable, Hashable, Codable {
  let id: String
  let projectId: String
  var stepNumber: Int
  var stepName: String
  var stepDesc: String
  var stepImageUrl: String?
  var isCompleted: Bool
}

extension ProjectStepModel {
  static var MOCK_STEPS: [ProjectStepModel] = [
    .init(
      id: "551A6B66-5E0C-4C96-AA4E-A154C2236781",
      projectId: "A753F134-DA85-4BA0-B3BD-7792919BEB6C",
      stepNumber: 1,
      stepName: "Main Branch Step One",
      stepDesc: "Test Step One",
      stepImageUrl: "",
      isCompleted: true
    )
  ]
}
