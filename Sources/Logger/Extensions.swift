//
//  File.swift
//  
//
//  Created by Aleksandr Milashevski on 13/09/21.
//

import UIKit

extension URLRequest: Loggable {
    public func getLogInfo() -> String {
        let url = self.url?.absoluteString ?? Logger.noValue
        let method = self.httpMethod ?? Logger.noValue
        let cachePolicy = self.cachePolicy.hashValue
        let timeInterval = self.timeoutInterval
        let header = Logger.dictToString(self.allHTTPHeaderFields)
        let body = Logger.dataToString(self.httpBody)
        return "\(Logger.url) \(url) \(Logger.method) \(method) \(Logger.header) \(header) \(Logger.cachePolicy) \(cachePolicy) \(Logger.timeInterval) \(timeInterval) \(Logger.body) \(body)"
    }
}

extension HTTPURLResponse: Loggable {
    public func getLogInfo() -> String {
        let url = self.url?.absoluteString ?? Logger.noValue
        let statusCode = self.statusCode
        let header = Logger.dictToString(self.allHeaderFields)
        return "\(Logger.url) \(url) \(Logger.statusCode) \(statusCode) \(Logger.header) \(header)"
    }
}

extension Data: Loggable {
    public func getLogInfo() -> String {
        let body = Logger.dataToString(self)
        return "\(Logger.body) \(body)"
    }
}

extension String: Loggable {
    public func getLogInfo() -> String {
        return "\n\n \(self)\n"
    }
}
// MARK: - Internal Extension for Date
extension Date {
    func toString() -> String {
        return Logger.dateFormatter.string(from: self as Date)
    }
}

// MARK: - Internal Extension for Collection
extension Collection {
    
    /// Convert self to JSON String.
    /// Returns: the pretty printed JSON string or an empty string if any error occur.
    func json() -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
            return String(data: jsonData, encoding: .utf8) ?? "{}"
        } catch {
            print("json serialization error: \(error)")
            return "{}"
        }
    }
}
