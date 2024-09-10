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
  @State private var showSheet = false

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
              NavigationLink(value: post) {
                KFImage(URL(string: post.imageUrl))
                  .resizable()
                  .scaledToFill()
                  .frame(width: imageDimension, height: imageDimension)
                  .clipped()
              }
            }
          }
        }
        .navigationDestination(
          for: PostModel.self,
          destination: { post in
            PostDetailView(user: viewModel.user, post: post, editable: true)
          }
        )
        .refreshable {
          Task { try await viewModel.fetchUserPosts() }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.automatic)
        .scrollIndicators(.never)
        .toolbar {
          ToolbarItem(placement: .topBarTrailing) {
            Button {
              //authViewModel.signOut()
              showSheet.toggle()
            } label: {
              Image(systemName: "gearshape.fill")
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
        .sheet(isPresented: $showSheet) {
          UserBottomSheet()
            .presentationDetents([.height(150)])
        }
      }
    }
  }
}

struct UserBottomSheet: View {
  @EnvironmentObject var authViewModel: AuthViewModel
  @Environment(\.dismiss) var dismiss
  @State private var showProgressView = false
  @State private var showLogoutAlert = false
  @State private var showDeleteAlert = false

  var body: some View {
    if !showProgressView {
      List {
        Button {
          showLogoutAlert.toggle()
        } label: {
          HStack(spacing: 10) {
            Image(systemName: "door.left.hand.open")
              .imageScale(.large)
            Text("Log out")
          }
          .foregroundColor(Color.blue)
        }
        .alert("Do you want to log out?", isPresented: $showLogoutAlert) {
          Button("Log out", role: .destructive) {
            showProgressView.toggle()
            authViewModel.signOut()
          }
        }

        Button {
          showDeleteAlert.toggle()
        } label: {
          HStack(spacing: 10) {
            Image(systemName: "trash.fill")
              .imageScale(.large)
            Text("Delete account")
          }
          .foregroundColor(Color.red)
        }
        .alert("Do you want to delete the account permanently?", isPresented: $showDeleteAlert) {
          Button("Delete", role: .destructive) {
            showProgressView.toggle()
            authViewModel.deleteAccount()
          }
        }
      }
    } else {
      ProgressView("Processing...")
    }
  }
}

#Preview{
  CurrentUserProfileView(user: UserModel.MOCK_USERS[0])
}
