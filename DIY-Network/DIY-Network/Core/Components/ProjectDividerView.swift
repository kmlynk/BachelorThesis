//
//  ProjectDividerView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 22.06.24.
//

import SwiftUI

struct ProjectDividerView: View {
  let minusWidth: CGFloat
  let height: CGFloat

  var body: some View {
    Rectangle()
      .frame(
        width: UIScreen.main.bounds.width - minusWidth,
        height: height)
  }
}

#Preview{
  ProjectDividerView(
    minusWidth: 10,
    height: 2)
}
