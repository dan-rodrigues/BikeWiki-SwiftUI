// BikeDetailHeaderView.swift
//
// Copyright (C) 2020 Dan Rodrigues <danrr.gh.oss@gmail.com>
//
// SPDX-License-Identifier: MIT

import SwiftUI

struct BikeDetailHeaderView: View {

    struct ViewModel {
        
        let summaryText: String
        let attributes: [Attribute]
    }
    
    @State private var detailsVisible = false

    private let viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        Button("Details") {
            withAnimation {
                detailsVisible.toggle()
            }
        }

        if detailsVisible {
            ForEach(viewModel.attributes) { attribute in
                DescriptionRowView(
                    title: attribute.name,
                    content: attribute.value
                )
            }
            .transition(.opacity)
            .padding(.init(top: 2, leading: 8, bottom: 2, trailing: 8))
        }
        
        Divider()

        Text(viewModel.summaryText)
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
            .padding(8)
    }
}

private struct DescriptionRowView: View {

    private let title: String
    private let content: String

    init(title: String, content: String) {
        self.title = title
        self.content = content
    }

    var body: some View {
        HStack {
            Text("\(title): ")
                .fontWeight(.bold)
            Text(content)
            Spacer()
        }
    }
}
