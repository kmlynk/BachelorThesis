//
//  PostDetailView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 04.08.24.
//

import SwiftUI

struct PostDetailView: View {
  @Environment(\.dismiss) var dismiss
  @State var user: UserModel
  @State var post: PostModel
  @State var editable: Bool
  @State private var showAlert = false
  @State private var showSuccess = false

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
            showAlert.toggle()
          } label: {
            Image(systemName: "trash.fill")
              .imageScale(.medium)
              .foregroundColor(.red)
          }
          .alert("Do you want to delete the post permanently?", isPresented: $showAlert) {
            Button("Delete", role: .destructive) {
              Task { try await PostService.deletePost(post: post) }
              showSuccess.toggle()
            }
          }
          .alert("Post deleted!", isPresented: $showSuccess) {
            Button("OK", role: .cancel) {
              dismiss()
            }
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
