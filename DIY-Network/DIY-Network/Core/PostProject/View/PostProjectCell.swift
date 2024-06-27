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
    HStack {
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
    .padding()
    .background(currentMode == .dark ? Color.black : Color.white)
    .cornerRadius(20)
    .shadow(color: Color.primary.opacity(0.08), radius: 5, x: 5, y: 5)
    .shadow(color: Color.primary.opacity(0.08), radius: 5, x: -5, y: -5)
    .padding(.horizontal)
    .padding(.top)
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
