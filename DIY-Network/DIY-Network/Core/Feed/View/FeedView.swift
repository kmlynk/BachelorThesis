//
//  FeedView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 27.06.24.
//

import SwiftUI

struct FeedView: View {
  @EnvironmentObject var authViewModel: AuthViewModel
  @StateObject var viewModel = FeedViewModel()
  @State var searchTerm = ""

  var filteredPosts: [PostModel] {
    guard !searchTerm.isEmpty else { return viewModel.sortedPosts }
    return viewModel.sortedPosts.filter {
      $0.labels.description.localizedCaseInsensitiveContains(searchTerm)
    }
  }

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(spacing: 16) {
          ForEach(filteredPosts, id: \.self) { post in
            Divider()
            if let user = authViewModel.currentUser {
              FeedCell(viewModel: FeedCellViewModel(post: post, user: user))
            }
          }
        }
      }
      .searchable(text: $searchTerm, prompt: "Search for a label...")
      .refreshable {
        Task { try await viewModel.fetchAllPosts() }
      }
      .scrollIndicators(.never)
      .navigationTitle("Discover")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Text("DIY Network")
            .font(.subheadline)
            .fontWeight(.bold)
        }
      }
    }
  }
}

#Preview{
  FeedView()
}
