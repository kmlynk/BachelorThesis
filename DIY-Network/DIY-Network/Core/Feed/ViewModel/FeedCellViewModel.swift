//
//  FeedCellViewModel.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 26.07.24.
//

import Firebase
import Foundation

@MainActor
class FeedCellViewModel: ObservableObject {
  let user: UserModel
  @Published var post: PostModel
  @Published var isLiked: Bool
  @Published var comment = ""

  init(post: PostModel, user: UserModel) {
    self.post = post
    self.user = user
    self.isLiked = post.likedBy?.contains(user.id) ?? false
  }

  func makeComment(user: UserModel) {
    Task {
      do {
        try await PostService.uploadComment(postId: post.id, text: comment, user: user)

        let newComment = CommentModel(
          id: UUID().uuidString,
          userName: user.username,
          userPic: user.profileImageUrl,
          text: comment,
          timestamp: Timestamp()
        )
        post.comments?.append(newComment)
        objectWillChange.send()
      } catch {
        print("DEBUG: Failed to add comment with error \(error.localizedDescription)")
      }
      comment = ""
    }
  }

  func toggleLike() {
    isLiked.toggle()
    post.likes += isLiked ? 1 : -1
    Task {
      do {
        try await PostService.handleLike(postId: post.id, user: user)
      } catch {
        isLiked.toggle()
        post.likes += isLiked ? 1 : -1
        print(
          "DEBUG: Failed to toggle like for post \(post.id) with error \(error.localizedDescription)"
        )
      }
    }
  }
}
