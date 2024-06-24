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
  @EnvironmentObject var authViewModel: AuthViewModel
  @StateObject var viewModel: EditProjectViewModel
  @State private var showProgressView = false
  @State var selectedImage: PhotosPickerItem?
  @State var name = ""
  @State var desc = ""

  init(project: ProjectModel) {
    self._viewModel = StateObject(wrappedValue: EditProjectViewModel(project: project))
  }

  var body: some View {
    if !showProgressView {
      ScrollView {
        HStack {
          Button {
            dismiss()
          } label: {
            Image(systemName: "chevron.left")
              .imageScale(.large)
          }

          Spacer()

          Text("Edit")
            .font(.headline)
            .fontWeight(.bold)

          Spacer()
        }
        .padding()

        ProjectDividerView(minusWidth: 0, height: 2)

        ZStack {
          VStack {
            PhotosPicker(selection: $selectedImage) {
              VStack {
                ProjectImageView(width: 100, height: 80, imageUrl: "")

                Text("Select a project image")
              }
            }
            .padding(.top)

            VStack {
              EditProjectRowView(title: "Project Name", placeholder: "Name", text: $name)

              EditProjectRowView(
                title: "Project Description", placeholder: "Description", text: $desc)
            }
            .padding()
          }
        }
        .frame(width: UIScreen.main.bounds.width - 10)

        VStack {
          Button {
            print("DEBUG: Saving the changes...")
          } label: {
            Text("Save the changes")
          }
          .modifier(InAppButtonModifier(width: 180, height: 50, radius: 30))

          Button {
            Task {
              print("DEBUG: Deleting the project...")
              showProgressView.toggle()
              try await viewModel.deleteProject()
            }
          } label: {
            VStack {
              Image(systemName: "trash")
                .imageScale(.large)

              Text("Delete the project")
            }
            .foregroundColor(Color.red)
          }
          .padding(.top, 40)
        }
      }
    } else {
      ProgressView("Deleting the project...")
    }
  }
}

struct EditProjectRowView: View {
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
  EditProjectView(project: ProjectModel.MOCK_PROJECTS[0])
}
