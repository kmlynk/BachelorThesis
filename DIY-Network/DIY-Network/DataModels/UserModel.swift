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
      username: "theAdmin",
      profileImageUrl: "https://firebasestorage.googleapis.com:443/v0/b/diy-network-75d15.appspot.com/o/images%2FC97FD051-4B84-4883-998E-4A3B49F72133?alt=media&token=e5aa1ac0-fe73-47e5-8e12-16761c74bf03"
    ),

    .init(
      id: NSUUID().uuidString,
      email: "testerOne@grr.la",
      username: "tester.one"
    ),
  ]
}
