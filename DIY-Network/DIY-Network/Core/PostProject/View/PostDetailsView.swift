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
                  .scaledToFill()
                  .frame(height: 400)
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

          GroupBox {
            HStack {
              Text("Caption")
                .fontWeight(.semibold)

              Spacer()
            }

            Divider()

            HStack {
              TextField("Enter here your caption", text: $viewModel.caption, axis: .vertical)
                .multilineTextAlignment(.leading)
            }
          }
          .font(.subheadline)
          .padding(.horizontal)

          GroupBox {
            HStack {
              Text("Label 1")
                .fontWeight(.semibold)

              Spacer()
            }

            Divider()

            HStack {
              TextField("Enter here the first label", text: $viewModel.label1, axis: .vertical)
                .multilineTextAlignment(.leading)
            }
          }
          .font(.subheadline)
          .padding(.horizontal)

          GroupBox {
            HStack {
              Text("Labels 2")
                .fontWeight(.semibold)

              Spacer()
            }

            Divider()

            HStack {
              TextField("Enter here the second label", text: $viewModel.label2, axis: .vertical)
                .multilineTextAlignment(.leading)
            }
          }
          .font(.subheadline)
          .padding(.horizontal)

          GroupBox {
            HStack {
              Text("Labels 3")
                .fontWeight(.semibold)

              Spacer()
            }

            Divider()

            HStack {
              TextField("Enter here the third label", text: $viewModel.label3, axis: .vertical)
                .multilineTextAlignment(.leading)
            }
          }
          .font(.subheadline)
          .padding(.horizontal)
        }
        .scrollIndicators(.never)
        .navigationTitle("Post Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .topBarLeading) {
            Button {
              dismiss()
            } label: {
              Image(systemName: "xmark")
            }
          }

          ToolbarItem(placement: .topBarTrailing) {
            Button {
              Task { try await viewModel.createPost() }
              dismiss()
            } label: {
              Text("Done")
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
