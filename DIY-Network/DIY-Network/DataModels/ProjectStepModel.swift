//
//  ProjectStepModel.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 16.06.24.
//

import Foundation

struct ProjectStepModel: Identifiable, Hashable, Codable {
  let id: String
  var name: String
  var description: String
  var stepImageUrl: String?
}
