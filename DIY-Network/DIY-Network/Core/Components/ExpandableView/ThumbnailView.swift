//
//  ThumbnailView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 21.06.24.
//

import SwiftUI

struct ThumbnailView: View, Identifiable {
  var id = UUID()
  @ViewBuilder var content: any View
  
  var body: some View {
    ZStack {
      AnyView(content)
    }
  }
}
