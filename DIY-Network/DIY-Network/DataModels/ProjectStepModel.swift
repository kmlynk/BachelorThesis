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
}
