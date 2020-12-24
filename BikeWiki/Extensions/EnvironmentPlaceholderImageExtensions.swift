// EnvironmentPlaceholderImageExtensions.swift
//
// Copyright (C) 2020 Dan Rodrigues <danrr.gh.oss@gmail.com>
//
// SPDX-License-Identifier: MIT

import Foundation
import SwiftUI

extension EnvironmentValues {

    var showPlaceholderImages: Bool {
        get { self[MyEnvironmentKey.self] }
        set { self[MyEnvironmentKey.self] = newValue }
    }
}

private struct MyEnvironmentKey: EnvironmentKey {

    static let defaultValue: Bool = false
}
