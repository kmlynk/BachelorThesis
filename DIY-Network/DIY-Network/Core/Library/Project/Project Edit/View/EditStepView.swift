//
//  EditStepView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 24.06.24.
//

import PhotosUI
import SwiftUI

struct EditStepView: View {
  @Environment(\.dismiss) var dismiss
  @StateObject var viewModel: EditStepViewModel
  @State private var showProgressView = false
  @State private var showAlert = false

  init(step: ProjectStepModel) {
    self._viewModel = StateObject(wrappedValue: EditStepViewModel(step: step))
  }

  var body: some View {
    if !showProgressView {
      NavigationStack {
        ScrollView {
          Divider()

          PhotosPicker(
            selection: $viewModel.selectedImages, matching: .images, photoLibrary: .shared()
          ) {
            VStack {
              if !viewModel.stepImages.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                  HStack(spacing: 10) {
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
                if let imageUrl = viewModel.step.stepImageUrls?.first {
                  ProjectImageView(width: 180, height: 120, imageUrl: imageUrl)
                } else {
                  Text("No image selected")
                }
              }

              Text("Select step images")
                .font(.footnote)
                .fontWeight(.semibold)
            }
          }
          .padding(.vertical)

          RowView(
            title: "Step Number", placeholder: "Number", text: $viewModel.number)

          RowView(title: "Step Name", placeholder: "Name", text: $viewModel.name)

          RowView(
            title: "Step Description", placeholder: "Description", text: $viewModel.desc)

        }
        .scrollIndicators(.never)
        .navigationTitle("Edit Step")
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
                try await viewModel.updateStep()
                if viewModel.error.isEmpty {
                  dismiss()
                } else {
                  showProgressView.toggle()
                  showAlert.toggle()
                }
              }
            } label: {
              Text("Done")
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

struct EditStepRowView: View {
  @Environment(\.colorScheme) var currentMode
  let title: String
  let placeholder: String
  @Binding var text: String

  var body: some View {
    ZStack {
      VStack {
        HStack {
          Text(title)
            .font(.headline)
            .fontWeight(.semibold)

          Spacer()
        }

        HStack {
          TextField(placeholder, text: $text, axis: .vertical)
            .multilineTextAlignment(.leading)
        }
        .font(.subheadline)

        Divider()
      }
      .padding()
    }
    .mask {
      RoundedRectangle(cornerRadius: 20, style: .continuous)
    }
    .background(currentMode == .dark ? Color.black : Color.white)
    .cornerRadius(20)
    .shadow(color: Color.primary.opacity(0.08), radius: 5, x: 5, y: 5)
    .shadow(color: Color.primary.opacity(0.08), radius: 5, x: -5, y: -5)
  }
}

#Preview{
  EditStepView(step: ProjectStepModel.MOCK_STEPS[0])
}
