// MockBikeCatalog.swift
//
// Copyright (C) 2020 Dan Rodrigues <danrr.gh.oss@gmail.com>
//
// SPDX-License-Identifier: MIT

import Foundation

struct MockBikeCatalog {

    static let bikes: [Bike] = [
        "CBX1000",
        "CX500",
        "CB500F",
        "CRF1000L",
        "SpeedTriple"
    ].compactMap { .mock(fromLocalJSON: $0) }
}
