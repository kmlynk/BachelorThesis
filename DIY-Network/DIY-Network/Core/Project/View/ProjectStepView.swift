//
//  ProjectStepView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 20.06.24.
//

import SwiftUI

struct ProjectStepView: View {
  @Environment(\.colorScheme) var currentMode
  @StateObject var viewModel: ProjectStepViewModel

  init(project: ProjectModel) {
    self._viewModel = StateObject(wrappedValue: ProjectStepViewModel(project: project))
  }

  var body: some View {
    LazyVStack {
      ForEach(viewModel.sortedSteps) { step in
        ExpandableView(
          thumbnail: ThumbnailView(content: {
            VStack {
              VStack {
                HStack {
                  Text("Step Number \(step.stepNumber)")

                  Spacer()

                  Button {
                    // Show Bottom Sheet
                  } label: {
                    Image(systemName: "ellipsis.circle")
                  }
                }

                ProjectDividerView(minusWidth: 60, height: 0.8)
              }
              .padding(.bottom, 5)

              HStack {
                if let imageUrl = step.stepImageUrl {
                  ProjectImageView(width: 100, height: 80, imageUrl: imageUrl)

                  Spacer()
                }

                Text(step.stepName)
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .foregroundColor(Color.white)
                  .font(.headline)
                  .fontWeight(.semibold)
                  .multilineTextAlignment(.leading)
              }
            }
            .padding()
            .background(currentMode == .dark ? Color.black : Color.white)
            .cornerRadius(20)
            .shadow(color: Color.primary.opacity(0.08), radius: 5, x: 5, y: 5)
            .shadow(color: Color.primary.opacity(0.08), radius: 5, x: -5, y: -5)
            .padding(.horizontal)
            .padding(.top)
          }),
          expanded: ExpandedView(content: {
            VStack {
              Text("\(step.stepNumber). \(step.stepName)")
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color.white)
                .font(.footnote)
                .lineLimit(2)

              ProjectDividerView(minusWidth: 60, height: 0.8)

              VStack {
                if let imageUrl = step.stepImageUrl {
                  ProjectImageView(width: 200, height: 260, imageUrl: imageUrl)
                    .padding(.vertical)
                }

                Text(step.stepDesc)
                  .font(.subheadline)
                  .fontWeight(.semibold)
                  .foregroundColor(Color.white)
                  .multilineTextAlignment(.leading)
              }
            }
            .padding()
            .background(currentMode == .dark ? Color.black : Color.white)
            .cornerRadius(20)
            .shadow(color: Color.primary.opacity(0.08), radius: 5, x: 5, y: 5)
            .shadow(color: Color.primary.opacity(0.08), radius: 5, x: -5, y: -5)
            .padding(.horizontal)
            .padding(.top)
          }),
          color: currentMode == .dark ? Color.black : Color.white)
      }
    }
    .onAppear(perform: {
      Task {
        try await viewModel.fetchProjectSteps()
      }
    })
  }
}

#Preview{
  ProjectStepView(project: ProjectModel.MOCK_PROJECTS[0])
}
