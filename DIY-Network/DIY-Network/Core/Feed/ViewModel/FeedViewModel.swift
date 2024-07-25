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
    if posts.count > 1 {
      self.sortedPosts = PostService.mergeSort(arr: posts)
    } else {
      self.sortedPosts = self.posts
    }
  }
}
