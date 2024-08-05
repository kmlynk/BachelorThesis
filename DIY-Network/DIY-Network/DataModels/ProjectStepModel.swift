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
      id: "3B415437-85F7-4EEF-A4CE-6979F987821A",
      projectId: "5B8A67E7-950C-46D9-8C36-D6EB36B418F1",
      stepNumber: 1,
      stepName: "Step Number One",
      stepDesc: "This is the first step",
      stepImageUrl:
        "https://firebasestorage.googleapis.com:443/v0/b/diy-network-75d15.appspot.com/o/images%2F008F7EBA-8A83-4A03-8144-501AABA58EB5?alt=media&token=21b1bb9c-a5b8-440f-85ec-f6c9fbf75179",
      isCompleted: true
    )
  ]
}
