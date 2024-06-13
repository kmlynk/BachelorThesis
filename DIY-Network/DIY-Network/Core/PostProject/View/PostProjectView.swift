//
//  PostProjectView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 13.06.24.
//

import Kingfisher
import PhotosUI
import SwiftUI

struct PostProjectView: View {
  @StateObject var viewModel = PostProjectViewModel()

  var body: some View {
    NavigationStack {
      ScrollView {
        Text("Only for Test Purposes")

        ForEach(viewModel.images) { image in
          CircularProfileImageView(size: 80, imageUrl: image.imageUrl)

          KFImage(URL(string: image.imageUrl))
            .placeholder {
              ProgressView()
            }
            .resizable()
            .scaledToFill()
            .frame(width: 400)
            .clipShape(Rectangle())
            .padding()
        }
      }
      .refreshable {
        Task { try await viewModel.fetchImages() }
      }
      .navigationTitle("Test")
      .navigationBarTitleDisplayMode(.inline)
      PhotosPicker(selection: $viewModel.selectedItem) {
        Text("Upload an Image")
          .foregroundColor(.blue)
      }
      .padding()
    }
  }
}

#Preview{
  PostProjectView()
}
