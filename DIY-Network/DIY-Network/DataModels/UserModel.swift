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
      id: "pwxKOtpz2iau4mI9Eh801GymAPw2",
      email: "admin@grr.la",
      username: "theAdmin",
      profileImageUrl:
        "https://firebasestorage.googleapis.com:443/v0/b/diy-network-75d15.appspot.com/o/images%2F290825E5-935D-4DA1-9977-FA3FC0E8B3BE?alt=media&token=634c21a9-91b6-4b0d-a4aa-5a559a09c7a9",
      fullname: "The Admin1",
      bio: "I am the Admin"
    ),

    .init(
      id: "KBorptK7rfTS0fXj8SPInzeIUxX2",
      email: "emptyuser@grr.la",
      username: "emptyUser"
    ),
  ]
}
