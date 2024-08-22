//
//  RowView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 23.08.24.
//

import SwiftUI

struct RowView: View {
  @Environment(\.colorScheme) var currentMode
  let title: String
  let placeholder: String
  @Binding var text: String

  var body: some View {
    GroupBox {
      TextField(placeholder, text: $text, axis: .vertical)
        .multilineTextAlignment(.leading)
    } label: {
      Text(title)
    }
    .frame(width: UIScreen.main.bounds.width - 30)
    .shadow(radius: 10)
    .padding(.vertical, 5)
  }
}

#Preview{
  RowView(title: "Title", placeholder: "Placeholder", text: .constant("Input"))
}
