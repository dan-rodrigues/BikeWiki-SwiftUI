// Attribute.swift
//
// Copyright (C) 2020 Dan Rodrigues <danrr.gh.oss@gmail.com>
//
// SPDX-License-Identifier: MIT

import Foundation

// This is distinct from Bike.Attribute which is used for (de)serializing
// This attribute model is kept separate to avoid accidental coupling of the two

struct Attribute: Identifiable {
    
    var id: String {
        return name
    }
    
    let name: String
    let value: String
}

extension Attribute {
    
    init(bikeAttribute: Bike.Attribute) {
        self.name = bikeAttribute.name
        self.value = bikeAttribute.value
    }
}
