//
//  EditProfileView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 16.06.24.
//

import PhotosUI
import SwiftUI

struct EditProfileView: View {
  @Environment(\.dismiss) var dismiss
  @EnvironmentObject var authViewModel: AuthViewModel
  @StateObject var viewModel: EditProfileViewModel
  @State private var showProgressView = false

  init(user: UserModel) {
    self._viewModel = StateObject(wrappedValue: EditProfileViewModel(user: user))
  }

  var body: some View {
    if showProgressView {
      ProgressView("Updating...")
    } else {
      VStack {
        VStack {
          HStack {
            Button("Cancel") {
              dismiss()
            }

            Spacer()

            Text("Edit Your Profile")
              .font(.subheadline)
              .fontWeight(.semibold)

            Spacer()

            Button("Done") {
              Task {
                showProgressView = true
                try await viewModel.updateUser()
                showProgressView = false
                dismiss()
              }
            }
            .font(.subheadline)
            .fontWeight(.bold)
          }
          .padding(.horizontal)
        }

        Divider()

        PhotosPicker(selection: $viewModel.selectedImage) {
          VStack {
            if let image = viewModel.profileImage {
              image
                .resizable()
                .clipShape(Circle())
                .frame(width: 80, height: 80)
            } else {
              CircularProfileImageView(size: 80, imageUrl: viewModel.user.profileImageUrl ?? "")
            }

            Text("Edit profile picture")
              .font(.footnote)
              .fontWeight(.semibold)
          }
        }
        .padding(.vertical, 10)

          RowView(
            title: "Fullname", placeholder: "Enter your name", text: $viewModel.fullname)

          RowView(title: "Bio", placeholder: "Enter your Bio", text: $viewModel.bio)
        
        Spacer()
      }
    }
  }
}

#Preview{
  EditProfileView(user: UserModel.MOCK_USERS[0])
}
