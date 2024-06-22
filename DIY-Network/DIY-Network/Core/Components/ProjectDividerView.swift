//
//  ProjectDividerView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 22.06.24.
//

import SwiftUI

struct ProjectDividerView: View {
  let height: CGFloat

  var body: some View {
    Rectangle()
      .frame(width: UIScreen.main.bounds.width, height: height)
  }
}

#Preview{
  ProjectDividerView(height: 2)
}
