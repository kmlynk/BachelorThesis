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
      projectId: "70293A4D-2BCC-4696-ACFB-B644B3BC5870",
      imageUrl:
        "https://firebasestorage.googleapis.com:443/v0/b/diy-network-75d15.appspot.com/o/images%2F99B838C4-785F-4D2F-A86E-5473BA78D1A4?alt=media&token=695015fe-453d-42e2-92da-9b3f207a9068",
      caption: "This is a test caption for a test project",
      likes: 1938,
      timestamp: Timestamp()
    )
  ]
}
