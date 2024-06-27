//
//  PostService.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 27.06.24.
//

import Firebase
import Foundation

struct PostService {
  private static let db = Firestore.firestore().collection("posts")

  static func uploadPostData(ownerId: String, projectId: String, imageUrl: String, caption: String)
    async throws
  {
    do {
      let post = PostModel(
        id: NSUUID().uuidString,
        ownerId: ownerId,
        projectId: projectId,
        imageUrl: imageUrl,
        caption: caption,
        likes: 0,
        timestamp: Timestamp()
      )
      let encodedPost = try Firestore.Encoder().encode(post)
      try await db.document(post.id).setData(encodedPost)
    } catch {
      print(
        "DEBUG: Failed to upload post data to database with error \(error.localizedDescription)")
    }
  }
}
