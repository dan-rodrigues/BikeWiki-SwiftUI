// UIApplicationExtensions.swift
//
// Copyright (C) 2020 Dan Rodrigues <danrr.gh.oss@gmail.com>
//
// SPDX-License-Identifier: MIT

import Foundation
import UIKit

// In certain cases we want resignFirstResponder programatically
// There is no SwiftUI API for this right now
//
// Reaching directly into the shared UIApplication instance is very dirty
// Doesn't look like there's an alternative at the moment using pure SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
