//
//  FeedCell.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 27.06.24.
//

import SwiftUI

struct FeedCell: View {
  var body: some View {
    VStack {
      HStack {
        CircularProfileImageView(size: 40, imageUrl: "")

        Text("UserName")
          .font(.footnote)
          .fontWeight(.semibold)

        Spacer()
      }
      .padding(.leading, 8)

      Image("panda")
        .resizable()
        .scaledToFill()
        .frame(height: 400)
        .clipShape(Rectangle())

      HStack(spacing: 16) {
        Button {
          print("Like Post")
        } label: {
          Image(systemName: "heart")
            .imageScale(.large)
        }

        Button {
          print("Comment on post")
        } label: {
          Image(systemName: "bubble.right")
            .imageScale(.large)
        }

        Spacer()

        Button {
          print("Add project to the library")
        } label: {
          Image(systemName: "square.and.arrow.down.on.square")
            .imageScale(.large)
        }
      }
      .padding(.horizontal, 8)
      .padding(.top, 4)
      .foregroundColor(Color.primary)

      Text("1938 likes")
        .font(.footnote)
        .fontWeight(.semibold)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 10)

      HStack {
        Text("UserName").fontWeight(.semibold) + Text("This is a text caption")
      }
      .font(.footnote)
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.leading, 10)
      .padding(.top, 1)

      Text("4h ago")
        .font(.footnote)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 10)
        .foregroundColor(Color.secondary)
    }
  }
}

#Preview{
  FeedCell()
}
