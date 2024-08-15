//
//  FeedCell.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 27.06.24.
//

import Firebase
import Kingfisher
import SwiftUI

struct FeedCell: View {
  @StateObject var viewModel: FeedCellViewModel
  @State private var showDetail = false

  var body: some View {
    VStack {
      HStack {
        if let user = viewModel.post.user {
          CircularProfileImageView(size: 40, imageUrl: user.profileImageUrl ?? "")

          Text(user.username)
            .font(.footnote)
            .fontWeight(.semibold)
        }

        Spacer()
      }
      .padding(.leading, 8)

      HStack {
        KFImage(URL(string: viewModel.post.imageUrl))
          .resizable()
          .frame(width: UIScreen.main.bounds.width, height: 400)
          .clipShape(Rectangle())
          .scaledToFill()
      }

      HStack(spacing: 16) {
        Button {
          viewModel.toggleLike()
        } label: {
          Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
            .imageScale(.large)
            .foregroundColor(viewModel.isLiked ? .red : .primary)
        }

        Button {
          print("Comment on post")
        } label: {
          Image(systemName: "bubble.right")
            .imageScale(.large)
        }

        Spacer()

        Button {
          showDetail.toggle()
          print("Add project to the library")
        } label: {
          Image(
            systemName: "folder"
          )
          .imageScale(.large)
        }
      }
      .padding(.horizontal, 8)
      .padding(.top, 4)
      .foregroundColor(Color.primary)

      Text("\(viewModel.post.likes) likes")
        .font(.footnote)
        .fontWeight(.semibold)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 10)

      HStack {
        Text("\(viewModel.post.user?.username ?? "") ").fontWeight(.semibold)
          + Text(viewModel.post.caption)
      }
      .font(.footnote)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.leading, 10)
      .padding(.top, 1)

      Text("Posted at \(viewModel.post.timestamp.dateValue().formatted(date: Date.FormatStyle.DateStyle.numeric, time: Date.FormatStyle.TimeStyle.omitted))")
        .font(.footnote)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 10)
        .foregroundColor(Color.secondary)
    }
    .sheet(isPresented: $showDetail) {
      ProjectDetailView(
        viewModel: ProjectDetailViewModel(user: viewModel.user, id: viewModel.post.projectId)
      )
      .presentationDetents([.medium, .large])
    }
  }
}

#Preview{
  FeedCell(
    viewModel: FeedCellViewModel(post: PostModel.MOCK_POSTS[0], user: UserModel.MOCK_USERS[0]))
}
