// BikeSumaryRowView.swift
//
// Copyright (C) 2020 Dan Rodrigues <danrr.gh.oss@gmail.com>
//
// SPDX-License-Identifier: MIT

import SwiftUI
import SDWebImageSwiftUI

struct BikeSummaryRowView: View {
    
    struct ViewModel {

        let thumbnailURL: URL
        let name: String
        let favouritesBinding: Binding<Bool>
    }
    
    private let viewModel: ViewModel

    @Environment(\.showPlaceholderImages) private var showPlaceholderImages: Bool
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Rectangle()
                    .fill(Color(.systemGray6))
                    .cornerRadius(8)
                HStack {
                    FavouritesToggleView(binding: viewModel.favouritesBinding)
                    Text(viewModel.name)
                    Spacer()

                    imageView(geo: geo)
                        .frame(width: geo.size.width / 2, height: geo.size.height, alignment: .center)
                        .cornerRadius(8)
                        .clipped()
                }
                .padding(.leading, 8)
            }
        }
    }

    private func imageView(geo: GeometryProxy) -> some View {
        return Group {
            if showPlaceholderImages {
                Rectangle()
                    .fill(Color.gray)
            } else {
                WebImage(url: viewModel.thumbnailURL)
                    .resizable()
                    .scaledToFill()
            }
        }
    }
}

extension BikeSummaryRowView.ViewModel {
    
    init(bike: Bike, favouritesBinding: Binding<Bool>) {
        self.thumbnailURL = bike.image.url
        self.name = bike.name
        self.favouritesBinding = favouritesBinding
    }
}
