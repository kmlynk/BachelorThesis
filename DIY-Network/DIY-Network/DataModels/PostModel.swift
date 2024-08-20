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
  var likedBy: [String]?
  var labels: [String]
  var comments: [CommentModel]?
}

extension PostModel {
  static var MOCK_POSTS: [PostModel] = [
    .init(
      id: "CF337909-EAFA-482B-B027-5A38A7EB99C7",
      ownerId: "pwxKOtpz2iau4mI9Eh801GymAPw2",
      projectId: "3276C1D2-7C16-46F4-9241-B7E2FF518D7C",
      imageUrl:
        "https://firebasestorage.googleapis.com:443/v0/b/diy-network-75d15.appspot.com/o/images%2FCA42FCCB-5BF0-4112-A49D-9F77F1ED39CA?alt=media&token=d2e295be-5f86-4b2e-b292-50597fab0733",
      caption: "This is the first post 🙂",
      likes: 1938,
      timestamp: Timestamp(),
      user: UserModel.MOCK_USERS[0],
      labels: ["Test", "Car"],
      comments: [
        CommentModel(
          id: NSUUID().uuidString,
          userName: UserModel.MOCK_USERS[0].username, 
          userPic: "https://firebasestorage.googleapis.com:443/v0/b/diy-network-75d15.appspot.com/o/images%2F290825E5-935D-4DA1-9977-FA3FC0E8B3BE?alt=media&token=634c21a9-91b6-4b0d-a4aa-5a559a09c7a9",
          text: "Very good idea!",
          timestamp: Timestamp()),
        CommentModel(
          id: NSUUID().uuidString,
          userName: UserModel.MOCK_USERS[1].username, 
          userPic: "", 
          text: "Congs",
          timestamp: Timestamp()),
      ]
    ),

    .init(
      id: NSUUID().uuidString,
      ownerId: "EVihsvJEqsNADP3bU0RnFXKtHwO2",
      projectId: "F7DBC26E-DB31-412D-92AB-03D944DFB0B5",
      imageUrl: "duck",
      caption: "I am a duck and I am graduated",
      likes: 10335,
      timestamp: Timestamp(),
      user: UserModel.MOCK_USERS[1],
      labels: [""]
    ),
  ]
}
