// FavouritesToggleView.swift
//
// Copyright (C) 2020 Dan Rodrigues <danrr.gh.oss@gmail.com>
//
// SPDX-License-Identifier: MIT

import SwiftUI

struct FavouritesToggleView: View {
    
    @Binding private(set) var binding: Bool
    
    var body: some View {
        Toggle(isOn: $binding) { EmptyView() }
            .toggleStyle(CheckboxToggleStyle())
            .fixedSize()
    }
}

private struct CheckboxToggleStyle: ToggleStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        return HStack {
            configuration.label
            Image(systemName: configuration.isOn ? "star.fill" : "star")
                .resizable()
                .frame(width: 22, height: 22)
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
}
