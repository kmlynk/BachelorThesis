//
//  ProjectModel.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 16.06.24.
//

import Foundation

struct ProjectModel: Identifiable, Hashable, Codable {
  var id: String
  var ownerId: String
  var projectName: String
  var projectDesc: String
  var projectImageUrl: String?
  var user: UserModel?
  var videoUrl: String?
  var ytVideoUrl: String?
}

extension ProjectModel {
  static var MOCK_PROJECTS: [ProjectModel] = [
    .init(
      id: "5B8A67E7-950C-46D9-8C36-D6EB36B418F1",
      ownerId: "pwxKOtpz2iau4mI9Eh801GymAPw2",
      projectName: "This is the Admin’s Project",
      projectDesc:
        "Initial Project of the Admin",
      projectImageUrl:
        "https://firebasestorage.googleapis.com:443/v0/b/diy-network-75d15.appspot.com/o/images%2F0FEC9107-EC81-4421-AE89-CCA80F84C2DA?alt=media&token=54a35f75-4a46-4f41-ac6a-e6e09a415012",
      ytVideoUrl: "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
    )
  ]
}
