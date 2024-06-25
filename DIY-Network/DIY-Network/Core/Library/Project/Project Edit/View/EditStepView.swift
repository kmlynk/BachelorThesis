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
  @State var selectedImage: PhotosPickerItem?

  init(step: ProjectStepModel) {
    self._viewModel = StateObject(wrappedValue: EditStepViewModel(step: step))
  }

  var body: some View {
    if !showProgressView {
      NavigationStack {
        ScrollView {
          ProjectDividerView(minusWidth: 0, height: 2)

          ZStack {
            VStack {
              PhotosPicker(selection: $viewModel.selectedImage) {
                VStack {
                  if let image = viewModel.stepImage {
                    image
                      .resizable()
                      .clipShape(Rectangle())
                      .frame(width: 180, height: 120)
                  } else {
                    ProjectImageView(
                      width: 180, height: 120, imageUrl: viewModel.step.stepImageUrl ?? "")
                  }

                  Text("Select a step image")
                    .font(.footnote)
                    .fontWeight(.semibold)
                }
              }
              .padding(.top)

              VStack {
                EditProjectRowView(
                  title: "Step Number", placeholder: "Number", text: $viewModel.number)

                EditProjectRowView(title: "Step Name", placeholder: "Name", text: $viewModel.name)

                EditProjectRowView(
                  title: "Step Description", placeholder: "Description", text: $viewModel.desc)
              }
              .padding(.top)
            }
          }
          .frame(width: UIScreen.main.bounds.width - 10)

          VStack {
            Button {
              Task {
                showProgressView.toggle()
                try await viewModel.updateStep()
                dismiss()
              }
            } label: {
              Text("Save the changes")
            }
            .modifier(InAppButtonModifier(width: 180, height: 50, radius: 30))
          }
        }
        .navigationTitle("Edit Step")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .topBarLeading) {
            Button {
              dismiss()
            } label: {
              Image(systemName: "chevron.left")
                .imageScale(.large)
            }
            .foregroundColor(Color.primary)
          }
        }
      }
    } else {
      ProgressView("Saving the changes...")
    }
  }
}

struct EditStepRowView: View {
  let title: String
  let placeholder: String
  @Binding var text: String

  var body: some View {
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
          .font(.subheadline)
      }

      ProjectDividerView(minusWidth: 30, height: 1)
    }
    .padding(.vertical, 10)
  }
}

#Preview{
  EditStepView(step: ProjectStepModel.MOCK_STEPS[0])
}
