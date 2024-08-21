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

  init(project: ProjectModel) {
    self._viewModel = StateObject(
      wrappedValue: AddProjectStepViewModel(project: project))
  }

  var body: some View {
    if !showProgressView {
      NavigationStack {
        ScrollView {
          ProjectDividerView(minusWidth: 0, height: 2)

          PhotosPicker(
            selection: $viewModel.selectedImages, maxSelectionCount: 5, matching: .images
          ) {
            VStack {
              if viewModel.stepImages.isEmpty {
                ProjectImageView(width: 100, height: 80, imageUrl: "")
                Text("Add Images to the Step")
                  .font(.footnote)
                  .fontWeight(.semibold)
              } else {
                ScrollView(.horizontal) {
                  HStack {
                    ForEach(Array(viewModel.stepImages.enumerated()), id: \.offset) {
                      index, image in
                      image
                        .resizable()
                        .clipShape(Rectangle())
                        .frame(width: 100, height: 80)
                    }
                  }
                }
              }
            }
          }
          .padding(.vertical)

          VStack {
            AddProjectStepRowView(
              title: "Step Number",
              placeholder: "Number",
              text: $viewModel.number)

            AddProjectStepRowView(
              title: "Step Name",
              placeholder: "Name",
              text: $viewModel.name)

            AddProjectStepRowView(
              title: "Step Description",
              placeholder: "Description",
              text: $viewModel.desc)

            Button {
              Task {
                showProgressView.toggle()
                try await viewModel.createNewStep()
                dismiss()
              }
            } label: {
              Text("Create the Step")
            }
            .modifier(InAppButtonModifier(width: 160, height: 50, radius: 30))
            .padding(.vertical)
          }
          .padding()
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
              Image(systemName: "xmark")
                .imageScale(.large)
            }
            .foregroundColor(Color.primary)
          }
        }
      }
    } else {
      ProgressView("Creating the Step...")
    }
  }
}

struct AddProjectStepRowView: View {
  @Environment(\.colorScheme) var currentMode
  let title: String
  let placeholder: String
  @Binding var text: String

  var body: some View {
    ZStack {
      VStack {
        HStack {
          Text(title)
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
  AddProjectStepView(project: ProjectModel.MOCK_PROJECTS[0])
}
