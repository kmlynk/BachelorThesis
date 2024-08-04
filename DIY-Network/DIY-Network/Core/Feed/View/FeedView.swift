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

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(spacing: 16) {
          ForEach(viewModel.sortedPosts, id: \.self) { post in
            Divider()
            if let user = authViewModel.currentUser {
              FeedCell(viewModel: FeedCellViewModel(post: post, user: user))
            }
          }
        }
      }
      .scrollIndicators(.never)
      .navigationTitle("Feed")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Text("DIY Network")
            .font(.subheadline)
            .fontWeight(.bold)
        }
      }
      .refreshable {
        Task { try await viewModel.fetchAllPosts() }
      }
    }
  }
}

#Preview{
  FeedView()
}
