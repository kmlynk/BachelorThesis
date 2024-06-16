//
//  CurrentUserProfileView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 15.06.24.
//

import SwiftUI

struct CurrentUserProfileView: View {
  @EnvironmentObject var authViewModel: AuthViewModel
  @State private var showEditProfile = false

  var body: some View {
    let user = authViewModel.currentUser

    NavigationStack {
      ScrollView {
        // Profile Header View
        VStack(spacing: 10) {
          HStack {
            CircularProfileImageView(size: 80, imageUrl: user?.profileImageUrl ?? "")
          }
          .padding(.top, 10)

          // Fullname and Bio if exists
          VStack(spacing: 5) {
            if let fullname = user?.fullname {
              Text(fullname)
                .font(.footnote)
                .fontWeight(.semibold)
            }

            if let bio = user?.bio {
              Text(bio)
                .font(.footnote)
            }
          }
          .frame(maxWidth: .infinity)
          .multilineTextAlignment(.center)
          .padding(.horizontal)

          // Edit Profile Button
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

          Divider()
        }
      }
      .fullScreenCover(isPresented: $showEditProfile) {
        EditProfileView(user: user!)
      }
      .navigationTitle("Profile")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarTrailing) {
          Button {
            authViewModel.signOut()
          } label: {
            Image(systemName: "gearshape.fill")
              .foregroundColor(Color.primary)
          }
        }
      }
    }
  }
}

#Preview{
  CurrentUserProfileView()
}
