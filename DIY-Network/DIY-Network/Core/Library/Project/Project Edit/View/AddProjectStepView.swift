//
//  AddProjectStepView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 20.06.24.
//

import PhotosUI
import SwiftUI

struct AddProjectStepView: View {
  @Environment(\.dismiss) var dismiss
  @StateObject var viewModel: AddProjectStepViewModel
  @State private var showProgressView = false
  @State private var showAlert = false

  init(project: ProjectModel) {
    self._viewModel = StateObject(
      wrappedValue: AddProjectStepViewModel(project: project))
  }

  var body: some View {
    if !showProgressView {
      NavigationStack {
        ScrollView {
          Divider()

          PhotosPicker(
            selection: $viewModel.selectedImages, maxSelectionCount: 5, matching: .images
          ) {
            VStack {
              if !viewModel.stepImages.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                  HStack(spacing: 8) {
                    ForEach(Array(viewModel.stepImages.enumerated()), id: \.offset) {
                      index, image in
                      image
                        .resizable()
                        .clipShape(Rectangle())
                        .frame(width: 180, height: 120)
                    }
                  }
                }
              } else {
                ProjectImageView(width: 180, height: 120, imageUrl: "")
              }

              Text("Select step images")
                .font(.footnote)
                .fontWeight(.semibold)
            }
          }
          .padding()

          RowView(
            title: "Step Number",
            placeholder: "Number",
            text: $viewModel.number)

          RowView(
            title: "Step Name",
            placeholder: "Name",
            text: $viewModel.name)

          RowView(
            title: "Step Description",
            placeholder: "Description",
            text: $viewModel.desc)

        }
        .scrollIndicators(.never)
        .navigationTitle("Create a Step")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
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
                try await viewModel.createNewStep()
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
      ProgressView("Creating the Step...")
    }
  }
}

#Preview{
  AddProjectStepView(project: ProjectModel.MOCK_PROJECTS[0])
}
