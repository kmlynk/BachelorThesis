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
}

extension ProjectModel {
  static var MOCK_PROJECTS: [ProjectModel] = [
    .init(
      id: "4389E0C6-A8F3-423B-A951-5EB768EB320B",
      ownerId: "pwxKOtpz2iau4mI9Eh801GymAPw2",
      projectName: "Admins Test Project",
      projectDesc:
        "Test Project",
      projectImageUrl:
        "https://firebasestorage.googleapis.com:443/v0/b/diy-network-75d15.appspot.com/o/images%2F0FEC9107-EC81-4421-AE89-CCA80F84C2DA?alt=media&token=54a35f75-4a46-4f41-ac6a-e6e09a415012"
    )
  ]
}
