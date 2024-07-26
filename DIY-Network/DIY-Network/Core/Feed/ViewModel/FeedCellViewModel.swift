//
//  FeedCellViewModel.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 26.07.24.
//

import Firebase
import Foundation

class FeedCellViewModel: ObservableObject {
  @Published var post: PostModel
  @Published var isLiked: Bool = false

  init(post: PostModel) {
    self.post = post
  }

  func likePost() {
    isLiked.toggle()
    post.likes += isLiked ? 1 : -1
    Task {
      do {
        try await PostService.likePost(postId: post.id, likeCount: post.likes)
      } catch {
        isLiked.toggle()
        post.likes += isLiked ? 1 : -1
        print("DEBUG: Error liking post: \(error.localizedDescription)")
      }
    }
  }
}
