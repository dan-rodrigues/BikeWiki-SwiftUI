// URLLocalImageExtensions.swift
//
// Copyright (C) 2020 Dan Rodrigues <danrr.gh.oss@gmail.com>
//
// SPDX-License-Identifier: MIT

import Foundation

extension URL {

    init(localImageResourceName name: String) {
        self.init(fileURLWithPath: Bundle.main.path(forResource: name, ofType: "jpg")!)
    }
}
