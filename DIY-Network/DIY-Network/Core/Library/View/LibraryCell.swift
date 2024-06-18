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
        if let imageUrl = project.projectImageUrl {
          CircularProfileImageView(size: 100, imageUrl: imageUrl)
        }

        Text(project.name)
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
