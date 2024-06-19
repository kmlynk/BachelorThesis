//
//  CreateProjectView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 17.06.24.
//

import PhotosUI
import SwiftUI

struct CreateProjectView: View {
  @Environment(\.dismiss) var dismiss
  @StateObject var viewModel: CreateProjectViewModel
  @State private var showProgressView = false
  @State var selectedImage: PhotosPickerItem?

  init(user: UserModel) {
    self._viewModel = StateObject(wrappedValue: CreateProjectViewModel(user: user))
  }

  var body: some View {
    if showProgressView {
      ProgressView("Creating Project...")
    } else {
      ScrollView {
        VStack {
          HStack {
            Button("Cancel") {
              dismiss()
            }

            Spacer()

            Text("Create a Project")
              .font(.subheadline)
              .fontWeight(.semibold)

            Spacer()

            Button("Done") {
              Task {
                showProgressView = true
                try await viewModel.createNewProject()
                showProgressView = false
                dismiss()
              }
            }
            .font(.subheadline)
            .fontWeight(.bold)
          }
          .padding(.horizontal)
        }
        .padding(.vertical)

        Divider()

        PhotosPicker(selection: $selectedImage) {
          VStack {
            CircularProfileImageView(size: 80, imageUrl: "")

            Text("Add a Project Picture")
              .font(.footnote)
              .fontWeight(.semibold)
          }
        }
        .padding(.vertical, 10)

        VStack(spacing: 10) {
          CreateProjectRowView(
            title: "Project Name",
            placeholder: "Name",
            text: $viewModel.projectName)

          CreateProjectRowView(
            title: "Project Describtion",
            placeholder: "Describtion",
            text: $viewModel.projectDesc)
        }
      }
    }
  }
}

struct CreateProjectRowView: View {
  let title: String
  let placeholder: String
  @Binding var text: String

  var body: some View {
    VStack(spacing: 10) {
      HStack {
        Text(title)
          .fontWeight(.semibold)

        Spacer()
      }

      HStack {
        TextField(placeholder, text: $text, axis: .vertical)
          .multilineTextAlignment(.leading)
      }

      Divider()
    }
    .font(.subheadline)
    .padding()
  }
}

#Preview{
  CreateProjectView(user: UserModel.MOCK_USERS[0])
}
