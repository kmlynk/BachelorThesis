//
//  ProfileView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 16.06.24.
//

import SwiftUI

struct ProfileView: View {
  let user: UserModel

  private let gridItems: [GridItem] = [
    .init(.flexible(), spacing: 5),
    .init(.flexible(), spacing: 5),
  ]
  
  private let imageDimension: CGFloat = (UIScreen.main.bounds.width / 2) - 1
  
  var posts: [PostModel] {
    return PostModel.MOCK_POSTS.filter({ $0.user?.username == user.username })
  }

  var body: some View {
    ScrollView {
      VStack {
        Spacer()

        VStack(spacing: 10) {
          HStack {
            CircularProfileImageView(size: 80, imageUrl: user.profileImageUrl ?? "")
          }
          .padding(.top, 10)

          VStack(spacing: 5) {
            if let fullname = user.fullname {
              Text(fullname)
                .font(.footnote)
                .fontWeight(.semibold)
            }

            if let bio = user.bio {
              Text(bio)
                .font(.footnote)
            }
          }
          .frame(maxWidth: .infinity)
          .multilineTextAlignment(.center)
          .padding(.horizontal)
        }

        ProjectDividerView(minusWidth: 0, height: 2)

        LazyVGrid(columns: gridItems, spacing: 5) {
          ForEach(posts) { post in
            Image(post.imageUrl)
              .resizable()
              .scaledToFill()
              .frame(width: imageDimension, height: imageDimension)
              .clipped()
          }
        }
        .padding(.top, 15)
      }
      .padding(.top, 20)
    }
    .navigationTitle(user.username)
    .navigationBarTitleDisplayMode(.inline)
  }
}

#Preview{
  ProfileView(user: UserModel.MOCK_USERS[0])
}
