// Manufacturer.swift
//
// Copyright (C) 2020 Dan Rodrigues <danrr.gh.oss@gmail.com>
//
// SPDX-License-Identifier: MIT

import Foundation

struct Manufacturer: Identifiable, Codable, Hashable {

    typealias ID = String

    let id: ID
    let name: String
}

extension Manufacturer {
    
    static let placeholder = Manufacturer(id: "0", name: "(Placeholder)")
}
