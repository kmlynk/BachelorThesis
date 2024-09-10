//
//  PostProjectCell.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 27.06.24.
//

import SwiftUI

struct PostProjectCell: View {
  @Environment(\.colorScheme) var currentMode
  let project: ProjectModel
  @State var showPostScreen = false

  var body: some View {
    GroupBox {
      HStack {
        ProjectImageView(
          width: 100,
          height: 100,
          imageUrl: project.projectImageUrl ?? ""
        )

        Text(project.projectName)
          .multilineTextAlignment(.leading)
          .fontWeight(.bold)

        Spacer()
      }
    }
    .cornerRadius(12)
    .shadow(color: Color.secondary, radius: 2)
    .frame(width: UIScreen.main.bounds.width - 30)
    .onTapGesture {
      showPostScreen.toggle()
    }
    .fullScreenCover(isPresented: $showPostScreen) {
      PostDetailsView(project: project)
    }
  }
}

#Preview{
  PostProjectCell(project: ProjectModel.MOCK_PROJECTS[0])
}
