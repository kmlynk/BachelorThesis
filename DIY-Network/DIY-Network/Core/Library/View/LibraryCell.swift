//
//  LibraryCell.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 16.06.24.
//

import SwiftUI

struct LibraryCell: View {
  @Environment(\.colorScheme) var currentMode
  let project: ProjectModel

  var body: some View {
    HStack {
      ProjectImageView(
        width: 100,
        height: 100,
        imageUrl: project.projectImageUrl ?? ""
      )

      Text(project.projectName)
        .multilineTextAlignment(.leading)
        .fontWeight(.heavy)

      Spacer()
    }
    .padding()
    .background(currentMode == .dark ? Color.black : Color.white)
    .cornerRadius(20)
    .shadow(color: Color.primary.opacity(0.08), radius: 5, x: 5, y: 5)
    .shadow(color: Color.primary.opacity(0.08), radius: 5, x: -5, y: -5)
    .padding(.horizontal)
    .padding(.top)
  }
}

#Preview{
  LibraryCell(project: ProjectModel.MOCK_PROJECTS[0])
}
