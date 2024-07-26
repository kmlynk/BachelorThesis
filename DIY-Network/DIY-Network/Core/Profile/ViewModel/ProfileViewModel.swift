//
//  ProfileViewModel.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 01.07.24.
//

import Foundation

@MainActor
class ProfileViewModel: ObservableObject {
  let user: UserModel
  @Published var posts = [PostModel]()
  @Published var sortedPosts = [PostModel]()

  init(user: UserModel) {
    self.user = user

    Task { try await fetchUserPosts() }
  }

  func fetchUserPosts() async throws {
    self.posts = try await PostService.fetchUserPosts(ownerId: user.id)
    if posts.count > 1 {
      self.sortedPosts = PostService.mergeSort(arr: posts)
    } else {
      self.sortedPosts = self.posts
    }
  }
}
