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
  @EnvironmentObject var authViewModel: AuthViewModel
  @StateObject var viewModel: FeedCellViewModel
  @State private var showDetail = false
  @State private var showLabels = false
  @State private var showComments = false

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
          .scaledToFill()
          .frame(width: UIScreen.main.bounds.width, height: 400)
          .clipped()
      }

      HStack(spacing: 16) {
        Button {
          viewModel.toggleLike()
        } label: {
          Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
            .imageScale(.large)
            .foregroundColor(viewModel.isLiked ? .red : .primary)
            .animation(.bouncy)
        }

        Button {
          showComments.toggle()
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

      HStack {
        Text(
          "Posted at \(viewModel.post.timestamp.dateValue().formatted(date: Date.FormatStyle.DateStyle.numeric, time: Date.FormatStyle.TimeStyle.omitted))"
        )
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundColor(Color.secondary)

        VStack {
          if showLabels {
            Button {
              showLabels.toggle()
            } label: {
              Text("Labels: \(viewModel.post.labels)")
            }
          } else {
            Button {
              showLabels.toggle()
            } label: {
              Text("See Labels")
            }
          }
        }
        .animation(.bouncy)
      }
      .font(.footnote)
      .padding(.horizontal, 10)
    }
    .sheet(isPresented: $showDetail) {
      ProjectDetailView(
        viewModel: ProjectDetailViewModel(user: viewModel.user, id: viewModel.post.projectId)
      )
      .presentationDetents([.medium, .large])
    }
    .sheet(isPresented: $showComments) {
      ScrollView {
        if let comments = viewModel.post.comments {
          VStack {
            ForEach(comments, id: \.self) { comment in
              HStack {
                CircularProfileImageView(size: 30, imageUrl: comment.userPic ?? "")

                Text("\(comment.userName) ").fontWeight(.semibold)
                  + Text(comment.text)
              }
              .font(.footnote)
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding(.horizontal, 10)

              Divider()
            }
          }
          .animation(.bouncy)
          .padding(.top)
        } else {
          VStack {
            Text("No comment")
          }
          .padding(.top)
        }

        GroupBox {
          HStack {
            Text("Comment")
              .fontWeight(.semibold)

            Spacer()
          }

          Divider()

          HStack {
            TextField("Enter here your comment", text: $viewModel.comment, axis: .vertical)
              .multilineTextAlignment(.leading)
          }
        }
        .font(.subheadline)
        .padding(.top)

        Button {
          viewModel.makeComment(user: authViewModel.currentUser!)
        } label: {
          Text("Send")
        }
        .modifier(InAppButtonModifier(width: 150, height: 40, radius: 10))
      }
      .presentationDetents([.height(250), .medium])
    }
  }
}

#Preview{
  FeedCell(
    viewModel: FeedCellViewModel(post: PostModel.MOCK_POSTS[0], user: UserModel.MOCK_USERS[0]))
}
