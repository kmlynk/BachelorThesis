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

  static func fetchUserPosts(ownerId: String) async throws -> [PostModel] {
    do {
      print("DEBUG: Fetching user posts...")
      let snapshot = try await db.whereField("ownerId", isEqualTo: ownerId).getDocuments()
      print("DEBUG: Posts fetched!")
      return try snapshot.documents.compactMap({ try $0.data(as: PostModel.self) })
    } catch {
      print("DEBUG: Failed to fetch user posts with error \(error.localizedDescription)")
      return []
    }
  }

  static func fetchAllPosts() async throws -> [PostModel] {
    do {
      print("DEBUG: Fetching all posts...")
      let snapshot = try await db.getDocuments()
      print("DEBUG: All posts fetched!")
      return try snapshot.documents.compactMap({ try $0.data(as: PostModel.self) })
    } catch {
      print("DEBUG: Failed to fetch all posts with error \(error.localizedDescription)")
      return []
    }
  }

  static func likePost(postId: String, likeCount: Int) async throws {
    var data = [String: Any]()

    data["likes"] = likeCount

    do {
      try await db.document(postId).updateData(data)
    } catch {
      print(
        "DEBUG: Failed to update like count in database with error \(error.localizedDescription)")
    }
  }

  /*
   Sorting algorithm for posts
   */
  static func mergeSort(arr: [PostModel]) -> [PostModel] {
    guard arr.count > 1 else { return arr }

    let leftArr = Array(arr[0..<arr.count / 2])
    let rightArr = Array(arr[arr.count / 2..<arr.count])

    return merge(left: mergeSort(arr: leftArr), right: mergeSort(arr: rightArr))
  }

  //  TODO: Be sure, that timestamp compare works
  static func merge(left: [PostModel], right: [PostModel]) -> [PostModel] {
    var mergedArr = [PostModel]()
    var left = left
    var right = right

    while left.count > 0 && right.count > 0 {
      if left.first!.timestamp.nanoseconds < right.first!.timestamp.nanoseconds {
        mergedArr.append(left.removeFirst())
      } else {
        mergedArr.append(right.removeFirst())
      }
    }

    return mergedArr + left + right
  }
}
