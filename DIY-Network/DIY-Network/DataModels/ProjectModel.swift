//
//  ProjectModel.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 16.06.24.
//

import Foundation

struct ProjectModel: Identifiable, Hashable, Codable {
  let id: String
  var ownerId: String
  var name: String
  var generalDescription: String?
  var projectImageUrl: String?
  var steps: [ProjectStepModel]?
}

extension ProjectModel {
  static var MOCK_PROJECTS: [ProjectModel] = [
    .init(
      id: NSUUID().uuidString,
      ownerId: NSUUID().uuidString,
      name: "Mock Project 001",
      generalDescription: "This is a Mock Project -> Mock Project 001",
      projectImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/diy-network-75d15.appspot.com/o/images%2FC97FD051-4B84-4883-998E-4A3B49F72133?alt=media&token=e5aa1ac0-fe73-47e5-8e12-16761c74bf03",
      steps: [
        ProjectStepModel(id: NSUUID().uuidString, name: "Step One", description: "This is Step One"),
        ProjectStepModel(id: NSUUID().uuidString, name: "Step Two", description: "This is Tep Two")
      ]
    )
  ]
}
