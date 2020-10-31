// BikiWikiApp.swift
//
// Copyright (C) 2020 Dan Rodrigues <danrr.gh.oss@gmail.com>
//
// SPDX-License-Identifier: MIT

import SwiftUI
import UIKit

@main
struct BikeWikiApp: App {

    @StateObject private var favourites = FavouritesStore()
    
    init() {
        initializeDependencyInjection()
    }
    
    // @StateObject allows a View to maintain state between instances
    // However, it doesn't allow an easy way to inject some implementation that maintains state
    // This fills that gap and allows a @StateObject instance to be initialized with an externally defined implementation
    private func initializeDependencyInjection() {
        ServiceProvider.shared.registerServices([
            .init(service: SearchPerforming.self) { _ in
                MockSearchPerformer()
            }
        ])
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(
                favourites: self.favourites
            )
        }
    }
}

/// Minimal DI service provider that is good enough for this basic demo app
/// A lot of expected features you'd expect from a fully-featured DI framework were left out

final class ServiceProvider {
    
    typealias Factory = (_ provider: ServiceProvider) -> Any
    
    static let shared = ServiceProvider()
    
    private var registeredServices: [ObjectIdentifier: Factory] = [:]
    private let registeredServicesQueue = DispatchQueue(label: "ServiceProvider.registeredServicesQueue")
    
    struct Service {
    
        let service: Any.Type
        let factory: Factory
        
        init<T>(service: T.Type, factory: @escaping (_ provider: ServiceProvider) -> T) {
            self.service = service
            self.factory = factory
        }
    }
    
    func registerServices(_ services: [Service]) {
        services.forEach {
            registeredServices[.init($0.service)] = $0.factory
        }
    }
    
    func implementor<Service>(of service: Service.Type) -> Service {
        return registeredServicesQueue.sync {
            guard let factory = registeredServices[.init(service)] else {
                fatalError("No service was registered for type: \(service)")
            }
            
            guard let implementor = factory(self) as? Service else {
                fatalError("Implementation doesn't match registered service: \(service)")
            }
            
            return implementor
        }
    }
}
