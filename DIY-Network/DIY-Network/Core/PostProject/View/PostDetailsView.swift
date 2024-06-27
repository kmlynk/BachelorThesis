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

  init(project: ProjectModel) {
    self._viewModel = StateObject(wrappedValue: PostDetailsViewModel(project: project))
  }

  var body: some View {
    NavigationStack {
      ScrollView {
        ProjectDividerView(minusWidth: 0, height: 2)
        
        VStack {
          Text(viewModel.project.projectName)
            .font(.title3)
            .fontWeight(.semibold)
        }
        .padding(.vertical)

        PhotosPicker(selection: $viewModel.selectedImage) {
          VStack {
            Text("Choose a new image for the post \n or continue with projects own image")
              .font(.footnote)
              .fontWeight(.semibold)
              .frame(maxWidth: UIScreen.main.bounds.width - 20)

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
          }
        }

        VStack {
          HStack {
            Text("Your Caption")
              .fontWeight(.semibold)
            
            Spacer()
          }
          
          HStack {
            TextField("Enter here your caption", text: $viewModel.caption, axis: .vertical)
              .multilineTextAlignment(.leading)
          }
          
          Divider()
        }
        .font(.subheadline)
        .padding()
        
        Button {
          print("DEBUG: Posting the project \(viewModel.project.projectName)")
          dismiss()
        } label: {
          Text("Post the project")
        }
        .modifier(InAppButtonModifier(width: 160, height: 50, radius: 30))
        .padding(.top, 16)
      }
      .scrollIndicators(.never)
      .navigationTitle("Configure your post")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button {
            dismiss()
          } label: {
            Image(systemName: "xmark")
              .imageScale(.large)
              .foregroundColor(Color.primary)
          }
        }
      }
    }
  }
}

#Preview{
  PostDetailsView(project: ProjectModel.MOCK_PROJECTS[0])
}
