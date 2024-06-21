//
//  ExpandableView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 21.06.24.
//

import SwiftUI

struct ExpandableView: View {
  @State var isExpanded = false
  @Namespace private var namespace
  var thumbnail: ThumbnailView
  var expanded: ExpandedView
  var color: Color

  var body: some View {
    ZStack {
      if !isExpanded {
        thumbnailView()
      } else {
        expandedView()
      }
    }
    .onTapGesture {
      if !isExpanded {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
          isExpanded.toggle()
        }
      }
    }
  }

  @ViewBuilder
  private func thumbnailView() -> some View {
    ZStack {
      thumbnail
        .matchedGeometryEffect(id: "view", in: namespace)
    }
    .background(
      color.opacity(0.7)
        .matchedGeometryEffect(id: "background", in: namespace)
    )
    .mask {
      RoundedRectangle(cornerRadius: 20, style: .continuous)
        .matchedGeometryEffect(id: "mask", in: namespace)
    }
  }

  @ViewBuilder
  private func expandedView() -> some View {
    ZStack {
      expanded
        .matchedGeometryEffect(id: "view", in: namespace)
        .background(
          color
            .matchedGeometryEffect(id: "background", in: namespace)
        )
        .mask {
          RoundedRectangle(cornerRadius: 20, style: .continuous)
            .matchedGeometryEffect(id: "mask", in: namespace)
        }

      Button {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
          isExpanded.toggle()
        }
      } label: {
        Image(systemName: "xmark")
          .foregroundColor(.white)
      }
      .padding()
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
      .matchedGeometryEffect(id: "mask", in: namespace)
    }
  }
}
