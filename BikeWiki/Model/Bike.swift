// Bike.swift
//
// Copyright (C) 2020 Dan Rodrigues <danrr.gh.oss@gmail.com>
//
// SPDX-License-Identifier: MIT

import Foundation

struct Bike: Identifiable, Codable, Equatable {

    typealias ID = String
    
    struct Attribute: Identifiable, Codable, Equatable {
        
        var id: String {
            return name
        }
        
        let name: String
        let value: String
    }

    struct Image: Equatable, Codable {
        
        enum Source: String, Codable {
            
            case local
        }
        
        let source: Source
        let resource: String
    }
    
    let id: ID
    let name: String
    let manufacturer: Manufacturer
    let image: Image
    let summary: String
    let attributes: [Attribute]
}

extension Bike {
    
    static let placeholder = Bike(
        id: "0",
        name: "(Placeholder bike)",
        manufacturer: .placeholder,
        image: .init(source: .local, resource: "CBX1000"),
        summary: "(Summary)",
        attributes: [.init(name: "(Attribute)", value: "(Value)")]
    )
}

extension Bike {
    
    /// Loads a `Bike` model from a given JSON file in the app bundle.
    ///
    /// This function will assert in debug builds if a JSON file with the given `name` doesn't exist or if loading otherwise fails.
    /// Since the absence of a JSON in the app bundle is programmer error, the debug assertions could potentially be replaced with fatal errors.
    ///
    /// If JSON resources are later loaded from a source outside the app bundle, such as a web API, this defensive approach should be used.
    
    static func mock(fromLocalJSON name: String) -> Bike? {
        guard let bundleURL = Bundle.main.path(forResource: name, ofType: "json") else {
            assertionFailure("Expected local JSON resource to exist: \(name)")
            return nil
        }
        
        let jsonData: Data
        do {
            jsonData = try Data(contentsOf: URL(fileURLWithPath: bundleURL))
        } catch let error {
            assertionFailure("Unexpected exception when loading JSON data from file: \(error)")
            return nil
        }
        
        guard !jsonData.isEmpty else {
            assertionFailure("JSON data unexpectedly empty at URL: \(jsonData)")
            return nil
        }
        
        do {
            return try JSONDecoder().decode(Bike.self, from: jsonData)
        } catch let error {
            assertionFailure("JSON decoding failed with error: \(error)")
            return nil
        }
    }
}

extension Bike.Image {
    
    var url: URL {
        switch self.source {
        case .local:
            return URL(localImageResourceName: self.resource)
        }
    }
}
