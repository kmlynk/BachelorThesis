//
//  CircularProfileImageView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 13.06.24.
//

import Kingfisher
import SwiftUI

struct CircularProfileImageView: View {
  let size: CGFloat
  var imageUrl: String

  var body: some View {
    if imageUrl != "" {
      KFImage(URL(string: imageUrl))
        .placeholder {
          ProgressView()
        }
        .resizable()
        .scaledToFill()
        .frame(width: size, height: size)
        .clipShape(Circle())
    } else {
      Image(systemName: "person.circle.fill")
        .resizable()
        .scaledToFill()
        .frame(width: size, height: size)
        .clipShape(Circle())
        .foregroundColor(Color.primary)
    }
  }
}

#Preview{
  CircularProfileImageView(size: 80, imageUrl: "")
}
