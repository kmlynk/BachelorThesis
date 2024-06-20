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

  init(user: UserModel, project: ProjectModel) {
    self._viewModel = StateObject(
      wrappedValue: AddProjectStepViewModel(user: user, project: project))
  }

  var body: some View {
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

      VStack(spacing: 10) {
        AddProjectStepRowView(
          title: "Step Name",
          placeholder: "Name",
          text: $viewModel.stepName
        )

        AddProjectStepRowView(
          title: "Step Description",
          placeholder: "Description",
          text: $viewModel.stepDesc
        )
      }
    }
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

#Preview{
  AddProjectStepView(user: UserModel.MOCK_USERS[0], project: ProjectModel.MOCK_PROJECTS[0])
}
