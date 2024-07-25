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
  @StateObject var viewModel = FeedViewModel()
  @State var post: PostModel
  @State private var isLiked = false

  var body: some View {
    VStack {
      HStack {
        if let user = post.user {
          CircularProfileImageView(size: 40, imageUrl: user.profileImageUrl ?? "")

          Text(user.username)
            .font(.footnote)
            .fontWeight(.semibold)
        }

        Spacer()
      }
      .padding(.leading, 8)

      KFImage(URL(string: post.imageUrl))
        .resizable()
        .scaledToFill()
        .frame(height: 400)
        .clipShape(Rectangle())

      HStack(spacing: 16) {
        Button {
          likePost()
          print("Like Post")
        } label: {
          Image(systemName: isLiked ? "heart.fill" : "heart")
            .imageScale(.large)
            .foregroundColor(isLiked ? .red : .primary)
        }

        Button {
          print("Comment on post")
        } label: {
          Image(systemName: "bubble.right")
            .imageScale(.large)
        }

        Spacer()

        Button {
          print("Add project to the library")
        } label: {
          Image(systemName: "square.and.arrow.down.on.square")
            .imageScale(.large)
        }
      }
      .padding(.horizontal, 8)
      .padding(.top, 4)
      .foregroundColor(Color.primary)

      Text("\(post.likes) likes")
        .font(.footnote)
        .fontWeight(.semibold)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 10)

      HStack {
        Text("\(post.user?.username ?? "") ").fontWeight(.semibold) + Text(post.caption)
      }
      .font(.footnote)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.leading, 10)
      .padding(.top, 1)

      var time = (Timestamp().seconds - post.timestamp.seconds) / 3600
      if time < 1 {
        Text("Less than an hour ago")
          .font(.footnote)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.leading, 10)
          .foregroundColor(Color.secondary)
      } else {
        Text("\(time)h ago")
          .font(.footnote)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.leading, 10)
          .foregroundColor(Color.secondary)
      }
    }
  }

  private func likePost() {
    isLiked.toggle()
    post.likes += isLiked ? 1 : -1
    Task {
      do {
        try await PostService.likePost(postId: post.id, likeCount: post.likes)
      } catch {
        // Handle error (e.g., revert like count change)
        isLiked.toggle()
        post.likes += isLiked ? 1 : -1
        print("Error liking post: \(error)")
      }
    }
  }
}

#Preview{
  FeedCell(post: PostModel.MOCK_POSTS[0])
}
