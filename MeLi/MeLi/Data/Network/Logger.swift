//
//  Logger.swift
//  MeLi
//
//  Created by Neto Moura on 15/12/25.
//

import Foundation

// MARK: - Logger
class Logger {
    static func logRequest(_ request: URLRequest) {
        print("\n🔵 ===== REQUEST =====")
        print("📍 URL: \(request.url?.absoluteString ?? "N/A")")
        print("📝 Method: \(request.httpMethod ?? "N/A")")
        
        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            print("📋 Headers:")
            headers.forEach { print("   \($0.key): \($0.value)") }
        }
        
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            print("📦 Body: \(bodyString)")
        }
        print("========================\n")
    }
    
    static func logResponse(_ response: URLResponse?, data: Data?, error: Error?) {
        print("\n🟢 ===== RESPONSE =====")
        
        if let httpResponse = response as? HTTPURLResponse {
            let statusEmoji = (200...299).contains(httpResponse.statusCode) ? "✅" : "❌"
            print("\(statusEmoji) Status: \(httpResponse.statusCode)")
            
            if !httpResponse.allHeaderFields.isEmpty {
                print("📋 Headers:")
                httpResponse.allHeaderFields.forEach { print("   \($0.key): \($0.value)") }
            }
        }
        
        if let data = data {
            print("📦 Data size: \(data.count) bytes")
            if let json = try? JSONSerialization.jsonObject(with: data),
               let prettyData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
               let prettyString = String(data: prettyData, encoding: .utf8) {
                print("📄 JSON Response:\n\(prettyString)")
            } else if let rawString = String(data: data, encoding: .utf8) {
                print("📄 Raw Response:\n\(rawString.prefix(500))")
            }
        }
        
        if let error = error {
            print("❌ Error: \(error.localizedDescription)")
        }
        
        print("========================\n")
    }
    
    static func logInfo(_ message: String) {
        print("ℹ️ INFO: \(message)")
    }
    
    static func logSuccess(_ message: String) {
        print("✅ SUCCESS: \(message)")
    }
    
    static func logError(_ message: String) {
        print("❌ ERROR: \(message)")
    }
    
    static func logWarning(_ message: String) {
        print("⚠️ WARNING: \(message)")
    }
}
