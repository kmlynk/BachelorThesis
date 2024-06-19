//
//  LibraryCell.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 16.06.24.
//

import SwiftUI

struct LibraryCell: View {
  let project: ProjectModel

  var body: some View {
    VStack {
      HStack(spacing: 15) {
        ProjectImageView(
          width: 100,
          height: 100,
          imageUrl: project.projectImageUrl ?? ""
        )
        
        Text(project.projectName)
          .multilineTextAlignment(.leading)
          .font(.callout)
          .fontWeight(.semibold)

        Spacer()
      }
      .padding(.leading, 20)
      .frame(width: 360, height: 120)
      .overlay(
        RoundedRectangle(cornerRadius: 10)
          .stroke(Color.primary, lineWidth: 2)
      )
    }
  }
}

#Preview{
  LibraryCell(project: ProjectModel.MOCK_PROJECTS[0])
}
