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
      id: "70293A4D-2BCC-4696-ACFB-B644B3BC5870",
      ownerId: "h9FV9ysmbOff2ZefQJEhjVs3yXi1",
      projectName: "Project Yago",
      projectDesc:
        "Creating best football reporter ever",
      projectImageUrl:
        "https://firebasestorage.googleapis.com:443/v0/b/diy-network-75d15.appspot.com/o/images%2F99B838C4-785F-4D2F-A86E-5473BA78D1A4?alt=media&token=695015fe-453d-42e2-92da-9b3f207a9068"
    )
  ]
}
