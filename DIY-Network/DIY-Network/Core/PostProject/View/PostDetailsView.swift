//
//  PostDetailsView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 27.06.24.
//

import PhotosUI
import SwiftUI

struct PostDetailsView: View {
  @Environment(\.dismiss) var dismiss
  @StateObject var viewModel: PostDetailsViewModel
  @State var showProgressView = false
  @State private var showAlert = false

  init(project: ProjectModel) {
    self._viewModel = StateObject(wrappedValue: PostDetailsViewModel(project: project))
  }

  var body: some View {
    if !showProgressView {
      NavigationStack {
        ScrollView {
          Divider()

          VStack {
            Text(viewModel.project.projectName)
              .font(.title3)
              .fontWeight(.semibold)
          }
          .padding(.vertical, 2)

          PhotosPicker(selection: $viewModel.selectedImage) {
            VStack {
              if let image = viewModel.postImage {
                image
                  .resizable()
                  .scaledToFit()
                  .frame(width: UIScreen.main.bounds.width)
                  .clipShape(Rectangle())
              } else {
                ProjectImageView(
                  width: 400, height: 400, imageUrl: viewModel.project.projectImageUrl ?? "")
              }

              Text("Choose a new image for the post \n or continue with projects own image")
                .font(.footnote)
                .fontWeight(.semibold)
                .frame(maxWidth: UIScreen.main.bounds.width - 20)
            }
          }

          RowView(
            title: "Caption", placeholder: "Enter here your caption", text: $viewModel.caption)

          RowView(
            title: "Label 1", placeholder: "Enter here the first label", text: $viewModel.label1)

          RowView(
            title: "Label 2", placeholder: "Enter here the second label", text: $viewModel.label2)

          RowView(
            title: "Label 3", placeholder: "Enter here the third label", text: $viewModel.label3)
        }
        .scrollIndicators(.never)
        .navigationTitle("Post Details")
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
                try await viewModel.createPost()
                if viewModel.error.isEmpty {
                  dismiss()
                } else {
                  showProgressView.toggle()
                  showAlert.toggle()
                }
              }
            } label: {
              Text("Done")
                .fontWeight(.bold)
            }
            .alert(viewModel.error, isPresented: $showAlert) {
              Button("OK", role: .cancel) {}
            }
          }
        }
      }
    } else {
      ProgressView("Posting...")
    }
  }
}

#Preview{
  PostDetailsView(project: ProjectModel.MOCK_PROJECTS[0])
}
