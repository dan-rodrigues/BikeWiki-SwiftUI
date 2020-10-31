// BikeDetailView.swift
//
// Copyright (C) 2020 Dan Rodrigues <danrr.gh.oss@gmail.com>
//
// SPDX-License-Identifier: MIT


import SwiftUI
import SDWebImageSwiftUI

struct BikeDetailView: View {
    
    struct ViewModel {
        
        let title: String
        let imageURL: URL
        let summary: String
        let attributes: [Attribute]
        
        let favouritesBinding: Binding<Bool>
    }
    
    private let viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    @State private var imageExpanded = false
    
    var body: some View {
        // Note GeometryReader must be the outer container view
        // If it's the inner one, the layout after image resizing doesn't work
        GeometryReader { geo in
            ScrollView {
                VStack {
                    WebImage(url: viewModel.imageURL)
                        .resizable()
                        .scaledToFit()
                        .frame(height: imageExpanded ? geo.size.width : 120, alignment: .center)
                        .cornerRadius(8)
                        .onTapGesture {
                            withAnimation {
                                imageExpanded.toggle()
                            }
                        }
                }
                BikeDetailHeaderView(viewModel: .init(summaryText: viewModel.summary, attributes: viewModel.attributes))
            }
        }
        .navigationBarTitle(viewModel.title)
        .navigationBarItems(trailing: FavouritesToggleView(binding: viewModel.favouritesBinding))
    }
}

extension BikeDetailView.ViewModel {
    
    init(bike: Bike, favouritesBinding: Binding<Bool>) {
        self.title = bike.name
        self.imageURL = bike.image.url
        self.summary = bike.summary
        self.favouritesBinding = favouritesBinding
        self.attributes = bike.attributes.map { .init(bikeAttribute: $0) }
    }
}
