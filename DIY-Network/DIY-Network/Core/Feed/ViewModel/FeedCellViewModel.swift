//
//  FeedCellViewModel.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 26.07.24.
//

import Firebase
import Foundation

class FeedCellViewModel: ObservableObject {
  let user: UserModel
  @Published var post: PostModel
  @Published var isLiked: Bool
  @Published var isImported: Bool

  init(post: PostModel, user: UserModel) {
    self.post = post
    self.user = user
    self.isLiked = post.likedBy?.contains(user.id) ?? false
    self.isImported = post.importedBy?.contains(user.id) ?? false
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

  func toggleImport() {
    isImported.toggle()
    Task {
      do {
        try await importProjectFromPost()
      } catch {
        isImported.toggle()
        print(
          "DEBUG: Failed to toggle import for post \(post.id) with error \(error.localizedDescription)"
        )
      }
    }
  }

  func importProjectFromPost() async throws {
    try await LibraryService.importProjectToUserLibrary(post: post, newOwner: user)
  }
}
