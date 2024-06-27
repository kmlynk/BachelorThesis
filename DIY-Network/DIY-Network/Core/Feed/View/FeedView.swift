//
//  FeedView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 27.06.24.
//

import SwiftUI

struct FeedView: View {
    var body: some View {
      NavigationStack {
        ScrollView {
          LazyVStack(spacing: 32) {
            ForEach(0...10, id: \.self) { post in
              FeedCell()
            }
          }
          .padding(.top, 8)
        }
        .scrollIndicators(.never)
        .navigationTitle("Feed")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .topBarLeading) {
            Text("DIY Network")
              .font(.subheadline)
              .fontWeight(.bold)
          }
        }
      }
    }
}

#Preview {
    FeedView()
}
