//
//  InAppButtonModifier.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 21.06.24.
//

import SwiftUI

struct InAppButtonModifier: ViewModifier {
  @Environment(\.colorScheme) var currentMode
  let width: CGFloat
  let height: CGFloat
  let radius: CGFloat

  func body(content: Content) -> some View {
    content
      .foregroundColor(currentMode == .dark ? Color.black : Color.white)
      .font(.subheadline)
      .fontWeight(.semibold)
      .frame(width: width, height: height)
      .background(currentMode == .dark ? Color.white : Color.black)
      .cornerRadius(radius)
  }
}
