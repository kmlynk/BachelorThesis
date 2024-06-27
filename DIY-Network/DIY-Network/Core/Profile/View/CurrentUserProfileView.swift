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
  
  private let gridItems: [GridItem] = [
    .init(.flexible(), spacing: 5),
    .init(.flexible(), spacing: 5)
  ]

  var body: some View {
    let user = authViewModel.currentUser

    NavigationStack {
      ScrollView {
        VStack(spacing: 10) {
          HStack {
            CircularProfileImageView(size: 80, imageUrl: user?.profileImageUrl ?? "")
          }
          .padding(.top, 10)

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
            ForEach(0 ... 15, id: \.self) { index in
              ProjectImageView(width: 190, height: 200, imageUrl: user?.profileImageUrl ?? "")
            }
          }
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
            Image(systemName: "door.left.hand.open")
              .imageScale(.large)
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
