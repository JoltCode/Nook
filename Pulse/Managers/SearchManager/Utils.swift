//
//  Utils.swift
//  Pulse
//
//  Created by Maciek Bagiński on 31/07/2025.
//

import Foundation
import SwiftUI

public func isValidURL(_ string: String) -> Bool {
    let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)

    if trimmed.isEmpty || trimmed.contains(" ") {
        return false
    }

    if let url = URL(string: trimmed),
        let scheme = url.scheme,
        ["http", "https", "file", "ftp"].contains(scheme.lowercased()),
        let host = url.host,
        !host.isEmpty
    {
        return true
    }

    return false
}

/// Normalizes a URL by adding protocol if missing
public func normalizeURL(_ input: String, provider: SearchProvider) -> String {
    let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)

    if trimmed.hasPrefix("http://") || trimmed.hasPrefix("https://") {
        return trimmed
    }

    if trimmed.contains(".") && !trimmed.contains(" ") {
        return "https://\(trimmed)"
    }

    let encoded =
        trimmed.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        ?? trimmed
    let urlString = String(format: provider.queryTemplate, encoded)
    return urlString
}

public func isLikelyURL(_ text: String) -> Bool {
    let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
    return trimmed.contains(".")
        && (trimmed.hasPrefix("http://") || trimmed.hasPrefix("https://")
            || trimmed.contains(".com") || trimmed.contains(".org")
            || trimmed.contains(".net") || trimmed.contains(".io")
            || trimmed.contains(".co") || trimmed.contains(".dev"))
}

public enum SearchProvider: String, CaseIterable, Identifiable, Codable,
    Sendable
{
    case google
    case duckDuckGo
    case bing
    case brave
    case yahoo

    public var id: String { rawValue }

    var displayName: String {
        switch self {
        case .google: return "Google"
        case .duckDuckGo: return "DuckDuckGo"
        case .bing: return "Bing"
        case .brave: return "Brave"
        case .yahoo: return "Yahoo"
        }
    }

    var host: String {
        switch self {
        case .google: return "www.google.com"
        case .duckDuckGo: return "duckduckgo.com"
        case .bing: return "www.bing.com"
        case .brave: return "search.brave.com"
        case .yahoo: return "search.yahoo.com"
        }
    }

    var queryTemplate: String {
        switch self {
        case .google:
            return "https://www.google.com/search?q=%@"
        case .duckDuckGo:
            return "https://duckduckgo.com/?q=%@"
        case .bing:
            return "https://www.bing.com/search?q=%@"
        case .brave:
            return "https://search.brave.com/search?q=%@"
        case .yahoo:
            return "https://search.yahoo.com/search?p=%@"
        }
    }
}
