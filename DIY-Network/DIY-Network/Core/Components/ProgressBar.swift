//
//  ProgressBar.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 01.08.24.
//

import SwiftUI

struct ProgressBar: View {
  var width: CGFloat = 200
  var height: CGFloat = 20
  var percent: CGFloat = 60
  var color1 = Color(.red)
  var color2 = Color(.blue)

  var body: some View {
    let multiplier = width / 100
    
    ZStack(alignment: .leading) {
      RoundedRectangle(cornerRadius: height, style: .continuous)
        .frame(width: width, height: height)
        .foregroundColor(Color.primary.opacity(0.1))

      RoundedRectangle(cornerRadius: height, style: .continuous)
        .frame(width: percent * multiplier, height: height)
        .background(
          LinearGradient(
            gradient: Gradient(colors: [color1, color2]), startPoint: .leading,
            endPoint: .trailing
          )
          .clipShape(RoundedRectangle(cornerRadius: height, style: .continuous))
        )
        .foregroundColor(Color.clear)
    }
  }
}

#Preview{
  ProgressBar()
}
