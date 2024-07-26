//
//  PostModel.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 27.06.24.
//

import Firebase
import Foundation

struct PostModel: Identifiable, Hashable, Codable {
  let id: String
  let ownerId: String
  let projectId: String
  let imageUrl: String
  let caption: String
  var likes: Int
  let timestamp: Timestamp
  var user: UserModel?
}

extension PostModel {
  static var MOCK_POSTS: [PostModel] = [
    .init(
      id: NSUUID().uuidString,
      ownerId: "h9FV9ysmbOff2ZefQJEhjVs3yXi1",
      projectId: "C2AEDABC-3A3A-4BDF-A2ED-AB2C8F54A4C3",
      imageUrl: "panda",
      caption: "This is a test caption for a test project",
      likes: 1938,
      timestamp: Timestamp(),
      user: UserModel.MOCK_USERS[0]
    ),

    .init(
      id: NSUUID().uuidString,
      ownerId: "EVihsvJEqsNADP3bU0RnFXKtHwO2",
      projectId: "F7DBC26E-DB31-412D-92AB-03D944DFB0B5",
      imageUrl: "duck",
      caption: "I am a duck and I am graduated",
      likes: 10335,
      timestamp: Timestamp(),
      user: UserModel.MOCK_USERS[1]
    ),
  ]
}
