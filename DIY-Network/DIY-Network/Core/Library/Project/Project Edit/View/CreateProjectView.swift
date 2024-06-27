//
//  CreateProjectView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 17.06.24.
//

import PhotosUI
import SwiftUI

struct CreateProjectView: View {
  @Environment(\.dismiss) var dismiss
  @StateObject var viewModel: CreateProjectViewModel
  @State private var showProgressView = false
  @State var selectedImage: PhotosPickerItem?

  init(user: UserModel) {
    self._viewModel = StateObject(wrappedValue: CreateProjectViewModel(user: user))
  }

  var body: some View {
    if !showProgressView {
      NavigationStack {
        ScrollView {
          ProjectDividerView(minusWidth: 0, height: 2)
          
          PhotosPicker(selection: $viewModel.selectedImage) {
            VStack {
              if let image = viewModel.projectImage {
                image
                  .resizable()
                  .clipShape(Rectangle())
                  .frame(width: 100, height: 80)
              } else {
                ProjectImageView(width: 100, height: 80, imageUrl: "")
              }

              Text("Add a Project Picture")
                .font(.footnote)
                .fontWeight(.semibold)
            }
          }
          .padding(.vertical)

          VStack {
            CreateProjectRowView(
              title: "Project Name",
              placeholder: "Name",
              text: $viewModel.projectName)

            CreateProjectRowView(
              title: "Project Describtion",
              placeholder: "Describtion",
              text: $viewModel.projectDesc)

            Button {
              Task {
                showProgressView.toggle()
                try await viewModel.createNewProject()
                dismiss()
              }
            } label: {
              Text("Create the project")
            }
            .modifier(InAppButtonModifier(width: 160, height: 44, radius: 30))
            .padding(.vertical)
          }
          .padding()
        }
        .scrollIndicators(.never)
        .navigationTitle("Create a Project")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .topBarLeading) {
            Button {
              dismiss()
            } label: {
              Image(systemName: "xmark")
            }
            .foregroundColor(Color.primary)
          }
        }
      }
    } else {
      ProgressView("Creating the project...")
    }
  }
}

struct CreateProjectRowView: View {
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
  CreateProjectView(user: UserModel.MOCK_USERS[0])
}
