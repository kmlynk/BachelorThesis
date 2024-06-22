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
  @State var selectedImage: PhotosPickerItem?

  init(user: UserModel, project: ProjectModel) {
    self._viewModel = StateObject(
      wrappedValue: AddProjectStepViewModel(user: user, project: project))
  }

  var body: some View {
    if !showProgressView {
      ScrollView {
        PhotosPicker(selection: $viewModel.selectedImage) {
          VStack {
            if let image = viewModel.stepImage {
              image
                .resizable()
                .clipShape(Rectangle())
                .frame(width: 100, height: 80)
            } else {
              ProjectImageView(width: 100, height: 80, imageUrl: "")
            }

            Text("Add a Image to the Step")
              .font(.footnote)
              .fontWeight(.semibold)
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
          .modifier(InAppButtonModifier(width: 160, height: 44, radius: 30))
        }
        .padding()
      }
      .navigationTitle("Create a Step")
      .navigationBarBackButtonHidden()
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button {
            dismiss()
          } label: {
            Image(systemName: "xmark")
          }
        }
      }
    } else {
      ProgressView("Creating the Step...")
    }
  }

  struct AddProjectStepRowView: View {
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
}

#Preview{
  AddProjectStepView(user: UserModel.MOCK_USERS[0], project: ProjectModel.MOCK_PROJECTS[0])
}
