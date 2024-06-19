//
//  ProjectHeaderView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 19.06.24.
//

import SwiftUI

struct ProjectHeaderView: View {
  let project: ProjectModel

  var body: some View {
    VStack(spacing: 15) {
      if let imageUrl = project.projectImageUrl {
        ProjectImageView(width: 180, height: 120, imageUrl: imageUrl)
      }

      Text(project.projectDesc)
        .font(.footnote)
        .fontWeight(.thin)
        .multilineTextAlignment(.center)

      Divider()
    }
    .padding([.top, .horizontal], 15)
  }
}

#Preview{
  ProjectHeaderView(project: ProjectModel.MOCK_PROJECTS[0])
}
