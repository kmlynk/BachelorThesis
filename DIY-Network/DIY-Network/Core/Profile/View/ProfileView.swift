//
//  ProfileView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 16.06.24.
//

import Kingfisher
import SwiftUI

struct ProfileView: View {
  @StateObject var viewModel: ProfileViewModel

  init(user: UserModel) {
    self._viewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
  }

  private let gridItems: [GridItem] = [
    .init(.flexible(), spacing: 5),
    .init(.flexible(), spacing: 5),
  ]

  private let imageDimension: CGFloat = (UIScreen.main.bounds.width / 2) - 1

  var body: some View {
    ScrollView {
      ProfileHeaderView(user: viewModel.user)

      ProjectDividerView(minusWidth: 0, height: 2)
        .padding(.vertical, 5)

      LazyVGrid(columns: gridItems, spacing: 5) {
        ForEach(viewModel.sortedPosts) { post in
          KFImage(URL(string: post.imageUrl))
            .resizable()
            .scaledToFill()
            .frame(width: imageDimension, height: imageDimension)
            .clipped()
        }
      }
      .padding(.top, 15)
    }
    .padding(.top, 20)
    .navigationTitle(viewModel.user.username)
    .navigationBarTitleDisplayMode(.inline)
  }
}

#Preview{
  ProfileView(user: UserModel.MOCK_USERS[0])
}
