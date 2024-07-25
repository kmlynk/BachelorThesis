//
//  FeedViewModel.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 01.07.24.
//

import Foundation

@MainActor
class FeedViewModel: ObservableObject {
  @Published var posts = [PostModel]()
  @Published var sortedPosts = [PostModel]()

  func fetchAllPosts() async throws {
    self.posts = try await PostService.fetchAllPosts()

    for i in 0 ..< posts.count {
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
}
