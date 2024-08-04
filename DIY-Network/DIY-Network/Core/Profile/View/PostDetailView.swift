//
//  PostDetailView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 04.08.24.
//

import SwiftUI

struct PostDetailView: View {
  var user: UserModel
  var post: PostModel
  var editable: Bool

  var body: some View {
    if editable {
      ScrollView {
        FeedCell(viewModel: FeedCellViewModel(post: post, user: user))
      }
      .navigationTitle("Post")
      .navigationBarTitleDisplayMode(.inline)
      .scrollIndicators(.hidden)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            print("DEBUG: Delete post")
          } label: {
            Image(systemName: "trash.fill")
          }
        }
      }
    } else {
      ScrollView {
        FeedCell(viewModel: FeedCellViewModel(post: post, user: user))
      }
      .navigationTitle("Post")
      .navigationBarTitleDisplayMode(.inline)
      .scrollIndicators(.hidden)
    }
  }
}

#Preview{
  PostDetailView(user: UserModel.MOCK_USERS[0], post: PostModel.MOCK_POSTS[0], editable: false)
}
