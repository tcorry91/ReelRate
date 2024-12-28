//
//  Environment.swift
//  ReelRate
//
//  Created by Corry Timothy on 28/12/2024.
//

import Foundation

import Foundation

class Environment {
    static func load() -> [String: String] {
        guard let path = Bundle.main.path(forResource: ".env", ofType: nil) else {
            print("⚠️ .env file not found!")
            return [:]
        }

        do {
            let content = try String(contentsOfFile: path, encoding: .utf8)
            var envVars: [String: String] = [:]
            let lines = content.split(whereSeparator: \.isNewline)
            for line in lines {
                let parts = line.split(separator: "=", maxSplits: 1)
                if parts.count == 2 {
                    let key = parts[0].trimmingCharacters(in: .whitespacesAndNewlines)
                    let value = parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
                    envVars[key] = value
                }
            }
            return envVars
        } catch {
            print("⚠️ Failed to load .env file: \(error)")
            return [:]
        }
    }
}
