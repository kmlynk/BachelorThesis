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

  static func uploadPostData(
    ownerId: String, projectId: String, imageUrl: String, caption: String, labels: [String]
  )
    async throws
  {
    do {
      let originProject = try await LibraryService.fetchSingleProject(withId: projectId)
      let originSteps = try await LibraryService.fetchProjectStepData(project: originProject)
      let postedProjectId = try await LibraryService.uploadPostedProjectData(project: originProject)

      for step in originSteps {
        if let imageUrls = step.stepImageUrls {
          await LibraryService.uploadPostedProjectStepData(
            projectId: postedProjectId,
            stepNumber: step.stepNumber,
            stepName: step.stepName,
            stepDesc: step.stepDesc,
            imageUrls: imageUrls
          )
        } else {
          await LibraryService.uploadPostedProjectStepData(
            projectId: postedProjectId,
            stepNumber: step.stepNumber,
            stepName: step.stepName,
            stepDesc: step.stepDesc,
            imageUrls: nil
          )
        }
      }

      let post = PostModel(
        id: NSUUID().uuidString,
        ownerId: ownerId,
        projectId: postedProjectId,
        imageUrl: imageUrl,
        caption: caption,
        likes: 0,
        timestamp: Timestamp(),
        labels: labels
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

  static func handleLike(postId: String, user: UserModel) async throws {
    let snapshot = try await db.document(postId).getDocument()
    var postData = try snapshot.data(as: PostModel.self)

    var likedBy = postData.likedBy ?? []
    let isLiked = likedBy.contains(user.id)

    if isLiked {
      likedBy.removeAll { $0 == user.id }
      postData.likes -= 1
    } else {
      likedBy.append(user.id)
      postData.likes += 1
    }

    let data: [String: Any] = [
      "likes": postData.likes,
      "likedBy": likedBy,
    ]

    do {
      try await db.document(postId).updateData(data)
    } catch {
      print("DEBUG: Failed to handle like in database with error \(error.localizedDescription)")
    }
  }

  static func uploadComment(postId: String, text: String, user: UserModel) async throws {
    let postRef = db.document(postId)

    // Create a new comment model
    let comment = CommentModel(
      id: UUID().uuidString,
      userName: user.username,
      userPic: user.profileImageUrl,
      text: text,
      timestamp: Timestamp()
    )

    do {
      _ = try await Firestore.firestore().runTransaction { (transaction, errorPointer) -> Any? in
        do {
          let postSnapshot = try transaction.getDocument(postRef)

          guard let postData = try? postSnapshot.data(as: PostModel.self) else {
            errorPointer?.pointee = NSError(
              domain: "FirestoreError", code: -1,
              userInfo: [NSLocalizedDescriptionKey: "Failed to decode post data"])
            return nil
          }

          // Append the new comment to the existing comments array
          var comments = postData.comments ?? []
          comments.append(comment)

          // Convert the comments array to a format Firestore can store
          let commentDictionaries = try comments.map { try Firestore.Encoder().encode($0) }

          // Update the comments array in Firestore
          transaction.updateData(["comments": commentDictionaries], forDocument: postRef)

        } catch let error {
          errorPointer?.pointee = error as NSError
          return nil
        }
        return nil
      }
    } catch {
      print("DEBUG: Failed to comment on post with error \(error.localizedDescription)")
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
      if left.first!.timestamp.seconds > right.first!.timestamp.seconds {
        mergedArr.append(left.removeFirst())
      } else {
        mergedArr.append(right.removeFirst())
      }
    }

    return mergedArr + left + right
  }
}
