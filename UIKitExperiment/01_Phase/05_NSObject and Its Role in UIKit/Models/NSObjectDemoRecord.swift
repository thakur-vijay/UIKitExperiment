//
//  NSObjectDemoRecord.swift
//  UIKitExperiment
//

import Foundation

final class NSObjectDemoRecord: NSObject {

    let title: String
    let purpose: String

    init(title: String, purpose: String) {
        self.title = title
        self.purpose = purpose
        super.init()
    }

    override var description: String {
        "\(title): \(purpose)"
    }
}
