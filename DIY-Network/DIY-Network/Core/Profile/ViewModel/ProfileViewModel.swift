//
//  ProfileViewModel.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 01.07.24.
//

import Foundation

@MainActor
class ProfileViewModel: ObservableObject {
  @Published var user: UserModel
  @Published var posts = [PostModel]()
  @Published var sortedPosts = [PostModel]()

  init(user: UserModel) {
    self.user = user
    Task { try await fetchUserPosts() }
  }

  func fetchUserPosts() async throws {
    self.posts = try await PostService.fetchUserPosts(ownerId: user.id)

    for i in 0..<posts.count {
      let post = posts[i]
      let ownerId = post.ownerId
      let postUser = try await UserService.fetchUser(withId: ownerId)
      posts[i].user = postUser
    }

    if posts.count > 1 {
      self.sortedPosts = PostService.mergeSort(arr: posts)
    } else {
      self.sortedPosts = self.posts
    }
  }

  func fetchUserData() async throws {
    self.user = try await UserService.fetchUser(withId: user.id)
  }
}
