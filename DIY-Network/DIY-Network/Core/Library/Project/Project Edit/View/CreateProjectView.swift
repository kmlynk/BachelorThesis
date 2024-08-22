//
//  CreateProjectView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 17.06.24.
//

import AVKit
import AZVideoPlayer
import PhotosUI
import SwiftUI

struct CreateProjectView: View {
  @Environment(\.dismiss) var dismiss
  @StateObject var viewModel: CreateProjectViewModel
  @State private var showProgressView = false
  @State private var error = ""
  @State private var showAlert = false

  init(user: UserModel) {
    self._viewModel = StateObject(wrappedValue: CreateProjectViewModel(user: user))
  }

  var body: some View {
    if !showProgressView {
      NavigationStack {
        ScrollView {
          Divider()

          PhotosPicker(selection: $viewModel.selectedImage, matching: .any(of: [.images])) {
            VStack {
              if let image = viewModel.projectImage {
                image
                  .resizable()
                  .clipShape(Rectangle())
                  .frame(width: 100, height: 80)
              } else {
                ProjectImageView(width: 100, height: 80, imageUrl: "")
              }

              Text("Add a Project Picture")
                .font(.footnote)
                .fontWeight(.semibold)
            }
          }
          .padding(.vertical)

          VStack {
            CreateProjectRowView(
              title: "Project Name",
              placeholder: "Name",
              text: $viewModel.projectName)

            CreateProjectRowView(
              title: "Project Describtion",
              placeholder: "Describtion",
              text: $viewModel.projectDesc)

            CreateProjectRowView(
              title: "YouTube Link",
              placeholder: "Link",
              text: $viewModel.ytLink)

            PhotosPicker(
              selection: $viewModel.selectedVideo, matching: .any(of: [.videos, .not(.images)])
            ) {
              VStack {
                if let video = viewModel.projectVideoData {
                  HStack {
                    Text("Video is loaded")

                    Image(systemName: "checkmark.circle.fill")
                  }
                } else {
                  VStack {
                    Image(systemName: "plus.circle")
                      .imageScale(.large)

                    Text("Upload a Video")
                  }
                }
              }
              .animation(.bouncy)
            }
            .padding(.vertical)
          }
          .padding()
        }
        .scrollIndicators(.never)
        .navigationTitle("Create a Project")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .topBarLeading) {
            Button {
              dismiss()
            } label: {
              Text("Cancel")
            }
          }

          ToolbarItem(placement: .topBarTrailing) {
            Button {
              Task {
                showProgressView.toggle()
                self.error = try await viewModel.createNewProject() ?? "Unable to create project"
                showProgressView.toggle()
              }
              if error != "" {
                showAlert.toggle()
              } else {
                dismiss()
              }
            } label: {
              Text("Create")
            }
            .alert(error, isPresented: $showAlert) {
              Button("OK", role: .cancel) {}
            }
          }
        }
      }
    } else {
      ProgressView("Creating the project...")
    }
  }
}

struct CreateProjectRowView: View {
  @Environment(\.colorScheme) var currentMode
  let title: String
  let placeholder: String
  @Binding var text: String

  var body: some View {
    GroupBox {
      TextField(placeholder, text: $text, axis: .vertical)
        .multilineTextAlignment(.leading)
    } label: {
      Text(title)
    }
    .frame(width: UIScreen.main.bounds.width - 30)
    .shadow(radius: 10)
    .padding(.horizontal)
    .padding(.vertical, 5)
  }
}

#Preview{
  CreateProjectView(user: UserModel.MOCK_USERS[0])
}
