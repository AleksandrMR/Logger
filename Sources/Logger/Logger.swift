
import UIKit

enum LogEvent: String {
    case error   = "🔴 ERROR"
    case warning = "🟡 WARNING"
    case success = "🟢 SUCCESS"
    case info    = "🔵 INFO"
    case debug   = "🟣 DEBUG"
}

public class Logger {
    
    // MARK: - Let
    public static let shared = Logger()
    
    init(){}
    
    // MARK: - Var
    static var dateFormat = "HH:mm:ss - MM/dd/yyyy"
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    static var isLoggingEnabled: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    // MARK: - Flow public funcs
    public func urlRequestPrint(_ urlRequest: URLRequest,
                                extra1: String = #file,
                                extra2: String = #function,
                                extra3: Int = #line) {
        if Logger.isLoggingEnabled {
            var body = Data()
            var header = [AnyHashable : Any]()
            
            let filename = (extra1 as NSString).lastPathComponent
            let url = urlRequest.url?.absoluteString ?? ""
            let method = urlRequest.httpMethod ?? ""
            let cachePolicy = String(describing: urlRequest.cachePolicy)
            let timeInterval = String(describing: urlRequest.timeoutInterval)
            
            if urlRequest.allHTTPHeaderFields != nil {
                header = urlRequest.allHTTPHeaderFields ?? [String : String]()
            }
            
            if urlRequest.httpBody != nil {
                body = urlRequest.httpBody ?? Data()
            }
            print("\n ⏰ Time: \(Date().toString())\n 📍 FileName: \(filename)\n 📍 Func: \(extra2)\n 📍 Line: \(extra3)\n ➖➖➖➖➖➖➖ ❗️ REQUEST❓ ➖➖➖➖➖➖➖ \(LogEvent.success.rawValue)\n 🌐 URL: \(url)\n Ⓜ️ METHOD: \(method)\n 🔒 HEADER: \(dictToString(header))\n 📀 CachePolicy: \(cachePolicy)\n ⏱ TimeInterval: \(timeInterval)\n 🔋 BODY: \(dataToString(body))\n")
        }
    }
    
    public func responseSuccess(_ data: Data?,
                                _ response: HTTPURLResponse,
                                extra1: String = #file,
                                extra2: String = #function,
                                extra3: Int = #line) {
        if Logger.isLoggingEnabled {
            var responseData = Data()
            let filename = (extra1 as NSString).lastPathComponent
            if data != nil {
                responseData = data ?? Data()
            }
            let url = response.url?.absoluteString ?? ""
            let statusCode = response.statusCode
            let header = response.allHeaderFields
            
            print("\n ⏰ Time: \(Date().toString())\n 📍 FileName: \(filename)\n 📍 Func: \(extra2)\n 📍 Line: \(extra3)\n ➖➖➖➖➖➖➖ ❗️ RESPONSE ❗️ ➖➖➖➖➖➖➖ \(LogEvent.success.rawValue)\n 🌐 URL: \(url)\n ⚠️ STATUS_CODE: \(statusCode)\n 🔒 HEADER: \(dictToString(header))\n 🔋 BODY: \(dataToString(responseData))\n")
        }
    }
    
    public func responseError(_ data: Data?,
                              _ response: HTTPURLResponse,
                              extra1: String = #file,
                              extra2: String = #function,
                              extra3: Int = #line) {
        if Logger.isLoggingEnabled {
            var responseData = Data()
            let filename = (extra1 as NSString).lastPathComponent
            if data != nil {
                responseData = data ?? Data()
            }
            let url = response.url?.absoluteString ?? ""
            let statusCode = response.statusCode
            let header = response.allHeaderFields
            
            print("\n ⏰ Time: \(Date().toString())\n 📍 FileName: \(filename)\n 📍 Func: \(extra2)\n 📍 Line: \(extra3)\n ➖➖➖➖➖➖➖ ❗️ RESPONSE ❗️ ➖➖➖➖➖➖➖ \(LogEvent.error.rawValue)\n 🌐 URL: \(url)\n ⚠️ STATUS_CODE: \(statusCode)\n 🔒 HEADER: \(dictToString(header))\n 🔋 BODY: \(dataToString(responseData))\n")
        }
    }
    
    public func debugPrint(_ message: Any,
                           extra1: String = #file,
                           extra2: String = #function,
                           extra3: Int = #line) {
        if Logger.isLoggingEnabled {
            let filename = (extra1 as NSString).lastPathComponent
            print("\n \(LogEvent.warning.rawValue)\n ⏱ Time: \(Date().toString())\n 📍 FileName: \(filename)\n 📍 Func: \(extra2)\n 📍 Line: \(extra3)\n 🔊 DEBUG_INFO:\n \(message)")
        }
    }
    
    public func dumpPrint(_ message: Any) {
        dump(message)
    }
    
    public func printDocumentsDirectory() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print("\n 🗄 Document Path:\n \(documentsPath)")
    }
    
    // MARK: - Flow internal funcs
    func print(_ object: Any) {
        // print object only in DEBUG mode
        #if DEBUG
        Swift.print(object)
        #endif
    }
    
    func dataToString(_ data: Data) -> String {
        let dict = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) ?? [:]
        let jsonDataAgain = (try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)) ?? Data()
        let jsonString = String(decoding: jsonDataAgain, as: UTF8.self)
        return jsonString
    }
    
    func dictToString(_ dict: [AnyHashable:Any]) -> String {
        let data = (try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)) ?? Data()
        let jsonString = String(data: data, encoding: .ascii) ?? ""
        return jsonString
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
