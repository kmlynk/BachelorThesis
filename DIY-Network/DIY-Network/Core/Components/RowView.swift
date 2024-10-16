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
    .cornerRadius(12)
    .frame(width: UIScreen.main.bounds.width - 30)
    .shadow(color: Color.secondary, radius: 3)
    .padding(.vertical, 5)
  }
}

#Preview{
  RowView(title: "Title", placeholder: "Placeholder", text: .constant("Input"))
}
