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
  var projectName: String
  var projectDesc: String
  var projectImageUrl: String?
  var steps: [ProjectStepModel]?
}

extension ProjectModel {
  static var MOCK_PROJECTS: [ProjectModel] = [
    .init(
      id: NSUUID().uuidString,
      ownerId: NSUUID().uuidString,
      projectName: "Mock Project 001",
      projectDesc:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque nunc massa, cursus eu dui ut, convallis sollicitudin dui. Proin blandit tellus ipsum, vel tempus lectus ullamcorper non. In varius aliquet neque, vitae venenatis eros convallis eu. Sed nunc lorem, consectetur sed laoreet sit amet, commodo ut eros. Praesent lacinia augue vitae nisl mollis luctus. Aenean laoreet efficitur nibh eget pellentesque. Quisque tempor accumsan quam ac semper. Etiam ornare interdum varius. Ut quis convallis massa, ut imperdiet mi. Sed porttitor ut purus eu laoreet. Donec eget consequat risus.",
      steps: [
        ProjectStepModel(
          id: NSUUID().uuidString, name: "Step One", description: "This is Step One"),
        ProjectStepModel(id: NSUUID().uuidString, name: "Step Two", description: "This is Tep Two"),
      ]
    )
  ]
}
