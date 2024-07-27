//
//  CurrentUserProfileView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 15.06.24.
//

import Kingfisher
import SwiftUI

struct CurrentUserProfileView: View {
  @EnvironmentObject var authViewModel: AuthViewModel
  @StateObject var viewModel: ProfileViewModel
  @State private var showEditProfile = false
  @State private var showProgressView = false

  init(user: UserModel) {
    self._viewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
  }

  private let gridItems: [GridItem] = [
    .init(.flexible(), spacing: 5),
    .init(.flexible(), spacing: 5),
  ]

  private let imageDimension: CGFloat = (UIScreen.main.bounds.width / 2) - 1

  var body: some View {
    NavigationStack {
      if showProgressView {
        ProgressView("Updating...")
      } else {
        ScrollView {
          ProfileHeaderView(user: viewModel.user)

          Button {
            showEditProfile.toggle()
          } label: {
            Text("Edit Profile")
              .font(.subheadline)
              .fontWeight(.semibold)
              .frame(width: 360, height: 32)
              .foregroundColor(Color.primary)
              .overlay(
                RoundedRectangle(cornerRadius: 10)
                  .stroke(Color.gray, lineWidth: 1)
              )
          }

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
        }
        .refreshable {
          Task { try await viewModel.fetchUserPosts() }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            Button {
              authViewModel.signOut()
            } label: {
              Image(systemName: "door.left.hand.open")
                .imageScale(.large)
                .foregroundColor(Color.primary)
            }
          }
        }
        .fullScreenCover(isPresented: $showEditProfile) {
          EditProfileView(user: viewModel.user)
            .onDisappear {
              Task { try await viewModel.fetchUserData() }
            }
        }
      }
    }
  }
}

#Preview{
  CurrentUserProfileView(user: UserModel.MOCK_USERS[0])
}
