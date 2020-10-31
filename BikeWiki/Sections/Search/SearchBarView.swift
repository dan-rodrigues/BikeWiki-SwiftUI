// SearchBarView.swift
//
// Copyright (C) 2020 Dan Rodrigues <danrr.gh.oss@gmail.com>
//
// SPDX-License-Identifier: MIT

import SwiftUI
import UIKit

struct SearchBarView: View {

    @Binding private var text: String
    @State private var isEditing = false

    init(text: Binding<String>) {
        self._text = text
    }
    
    var body: some View {
        HStack {
            TextField("Search…", text: $text, onEditingChanged: {
                isEditing = $0
            })
            .padding(7)
            .padding(.horizontal, 25)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal, 10)

            if isEditing {
                Button(action: {
                    isEditing = false
                    text = ""
                    UIApplication.shared.endEditing()
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
            }
        }
        .padding(.init(top: 0, leading: 0, bottom: 8, trailing: 0))
    }
}
