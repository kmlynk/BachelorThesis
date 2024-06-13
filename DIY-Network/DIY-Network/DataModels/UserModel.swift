//
//  UserModel.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 13.06.24.
//

import Firebase
import Foundation

struct UserModel: Identifiable, Hashable, Codable {
  let id: String
  let email: String
  var username: String
  var profileImageUrl: String?
  var fullname: String?
  var bio: String?
}

extension UserModel {
  static var MOCK_USERS: [UserModel] = [
    .init(
      id: NSUUID().uuidString,
      email: "admin@grr.la",
      username: "theAdmin"
    ),

    .init(
      id: NSUUID().uuidString,
      email: "testerOne@grr.la",
      username: "tester.one"
    ),
  ]
}
