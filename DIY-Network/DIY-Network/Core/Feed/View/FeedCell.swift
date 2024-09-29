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
  @State private var showComments = false
  @GestureState private var zoom = 1.0
  @State private var showProgress = false

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
        if #available(iOS 17.0, *) {
          KFImage(URL(string: viewModel.post.imageUrl))
            .resizable()
            .scaledToFit()
            .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: 400)
            .clipped()
            .scaleEffect(zoom)
            .gesture(
              MagnifyGesture()
                .updating(
                  $zoom,
                  body: { value, gestureState, transaction in
                    gestureState = value.magnification
                  }
                )
            )
        } else {
          KFImage(URL(string: viewModel.post.imageUrl))
            .resizable()
            .scaledToFit()
            .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: 400)
            .clipped()
        }
      }

      HStack(spacing: 16) {
        Button {
          viewModel.toggleLike()
        } label: {
          Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
            .imageScale(.large)
            .foregroundColor(viewModel.isLiked ? .red : .primary)
            .animation(.linear)
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
        if viewModel.post.comments!.count > 0 {
          let comments = viewModel.post.comments
          VStack {
            ForEach(comments!, id: \.self) { comment in
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
          .animation(.linear)
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

        if !showProgress {
          Button {
            Task {
              showProgress.toggle()
              viewModel.makeComment(user: authViewModel.currentUser!)
              showProgress.toggle()
            }
          } label: {
            Text("Send")
          }
          .modifier(InAppButtonModifier(width: 150, height: 40, radius: 10))
        } else {
          ProgressView("Sending...")
        }
      }
      .presentationDetents([.height(250), .medium])
    }
  }
}

#Preview{
  FeedCell(
    viewModel: FeedCellViewModel(post: PostModel.MOCK_POSTS[0], user: UserModel.MOCK_USERS[0]))
}
