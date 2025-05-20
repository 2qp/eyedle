//
//  FileManagerServiceProtocol.swift
//  Core
//
//  Created by 2qp on 2025-05-20.
//

import Foundation

public protocol FileManagerServiceProtocol {

    func createDirectoryIfNeeded(at path: String) -> Bool
}
