//
//  EditProjectView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 23.06.24.
//

import PhotosUI
import SwiftUI

struct EditProjectView: View {
  @Environment(\.dismiss) var dismiss
  @StateObject var viewModel: EditProjectViewModel
  @State private var showProgressView = false
  @State private var showAlert = false

  init(project: ProjectModel) {
    self._viewModel = StateObject(wrappedValue: EditProjectViewModel(project: project))
  }

  var body: some View {
    if !showProgressView {
      NavigationStack {
        ScrollView {
          Divider()

          PhotosPicker(selection: $viewModel.selectedImage) {
            VStack {
              if let image = viewModel.projectImage {
                image
                  .resizable()
                  .clipShape(Rectangle())
                  .frame(width: 180, height: 120)
              } else {
                ProjectImageView(
                  width: 180, height: 120, imageUrl: viewModel.project.projectImageUrl ?? "")
              }

              Text("Select a project image")
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundColor(Color.blue)
            }
          }
          .padding(.vertical)

          RowView(
            title: "Project Name", placeholder: "Name", text: $viewModel.name)

          RowView(
            title: "Project Description", placeholder: "Description", text: $viewModel.desc)

        }
        .scrollIndicators(.never)
        .navigationTitle("Edit Project")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .topBarLeading) {
            Button {
              dismiss()
            } label: {
              Text("Cancel")
                .foregroundColor(Color.blue)
            }
          }

          ToolbarItem(placement: .topBarTrailing) {
            Button {
              Task {
                showProgressView.toggle()
                try await viewModel.updateProject()
                if viewModel.error.isEmpty {
                  dismiss()
                } else {
                  showProgressView.toggle()
                  showAlert.toggle()
                }
              }
            } label: {
              Text("Done")
                .foregroundColor(Color.blue)
            }
            .alert(viewModel.error, isPresented: $showAlert) {
              Button("OK", role: .cancel) {}
            }
          }
        }
      }
    } else {
      ProgressView("Saving the changes...")
    }
  }
}

#Preview{
  EditProjectView(project: ProjectModel.MOCK_PROJECTS[0])
}
