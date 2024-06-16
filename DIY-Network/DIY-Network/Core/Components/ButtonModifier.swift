//
//  ButtonModifier.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 15.06.24.
//

import SwiftUI

struct ButtonModifier: ViewModifier {
  @Environment(\.colorScheme) var currentMode

  func body(content: Content) -> some View {
    content
      .foregroundColor(currentMode == .dark ? Color.black : Color.white)
      .font(.subheadline)
      .fontWeight(.semibold)
      .frame(width: 360, height: 44)
      .background(currentMode == .dark ? Color.white : Color.black)
      .cornerRadius(10)
  }
}
