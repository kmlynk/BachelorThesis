//
//  NewExpandableView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 06.08.24.
//

import SwiftUI

struct NewExpandableView: View {
  @State private var isExpanded = false

  var body: some View {
    VStack {
      if !isExpanded {
        GroupBox {
          Text("This is the Thumbnail View Box")

          GroupBox {
            Text("This is the Inner Group Box")
          }
        } label: {
          Text("This is the Thumbnail Group Title")
        }
      } else {
        GroupBox {
          Text("This is the Expanded View")

          GroupBox {
            Text("This is the Inner Group Box")
          }
        } label: {
          Text("This is the Expanded View Title")
        }
      }
    }
    .onTapGesture {
      isExpanded.toggle()
    }
  }
}

#Preview{
  NewExpandableView()
}
