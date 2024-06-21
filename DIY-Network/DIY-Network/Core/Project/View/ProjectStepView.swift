//
//  ProjectStepView.swift
//  DIY-Network
//
//  Created by Kamil Uyanık on 20.06.24.
//

import SwiftUI

struct ProjectStepView: View {
  @StateObject var viewModel: ProjectStepViewModel

  init(project: ProjectModel) {
    self._viewModel = StateObject(wrappedValue: ProjectStepViewModel(project: project))
  }

  var body: some View {
    ZStack {
      ScrollView {
        LazyVStack {
          ForEach(viewModel.sortedSteps) { step in
            ExpandableView(
              thumbnail: ThumbnailView(content: {
                VStack {
                  HStack {
                    if let imageUrl = step.stepImageUrl {
                      ProjectImageView(width: 100, height: 80, imageUrl: imageUrl)

                      Spacer()
                    }

                    Text("\(step.stepNumber). \(step.stepName)")
                      .frame(maxWidth: .infinity, alignment: .leading)
                      .foregroundColor(Color.white)
                      .font(.headline)
                      .fontWeight(.semibold)
                      .multilineTextAlignment(.leading)
                  }
                }
                .padding()
              }),
              expanded: ExpandedView(content: {
                VStack {
                  Text("\(step.stepNumber). \(step.stepName)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color.white)
                    .font(.footnote)
                    .lineLimit(2)
                    

                  Divider()

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
              }),
              color: Color.secondary)
          }
        }
        .padding()
      }
      .navigationTitle("Steps")
      .navigationBarTitleDisplayMode(.inline)
    }
  }
}

#Preview{
  ProjectStepView(project: ProjectModel.MOCK_PROJECTS[0])
}
