//
//  ProjectImageView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 19.06.24.
//

import Kingfisher
import SwiftUI

struct ProjectImageView: View {
  let width: CGFloat
  let height: CGFloat
  var imageUrl: String

  var body: some View {
    if imageUrl != "" {
      KFImage(URL(string: imageUrl))
        .placeholder {
          ProgressView()
        }
        .resizable()
        .scaledToFit()
        .frame(width: width, height: height)
        .clipShape(Rectangle())
    } else {
      Image(systemName: "photo")
        .resizable()
        .scaledToFit()
        .frame(width: width, height: height)
        .clipShape(Rectangle())
        .foregroundColor(Color.primary)
    }
  }
}

#Preview{
  ProjectImageView(
    width: 360,
    height: 400,
    imageUrl:
      "https://firebasestorage.googleapis.com:443/v0/b/diy-network-75d15.appspot.com/o/images%2FB8511C3C-425D-467A-B671-69A36F4663E1?alt=media&token=15be537d-825f-4a79-acfa-01ffdfb560ca"
  )
}
