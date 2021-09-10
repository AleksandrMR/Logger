
import UIKit

internal enum LogEvent: String {
    case error   = "🔴 ERROR"
    case warning = "🟡 WARNING"
    case success = "🟢 SUCCESS"
    case info    = "🔵 INFO"
    case debug   = "🟣 DEBUG"
}

public class Logger {
    
    // MARK: - Let
    public static let shared = Logger()
    
    public init(){}
    
    // MARK: - Var
    private static var dateFormat = "HH:mm:ss - MM/dd/yyyy"
    internal static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    internal static var isLoggingEnabled: Bool {
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
            var header = [String : String]()
            
            let filename = (extra1 as NSString).lastPathComponent
            let url = String(describing: urlRequest.debugDescription)
            let method = urlRequest.httpMethod ?? ""
            let cachePolicy = String(describing: urlRequest.cachePolicy)
            let timeInterval = String(describing: urlRequest.timeoutInterval)
            
            if urlRequest.allHTTPHeaderFields != nil {
                header = urlRequest.allHTTPHeaderFields ?? [String : String]()
            }
            
            if urlRequest.httpBody != nil {
                body = urlRequest.httpBody ?? Data()
            }
            print(" \(LogEvent.success.rawValue)\n ⏰ Time: \(Date().toString())\n 📍 FileName: \(filename)\n 📍 Func: \(extra2)\n 📍 Line: \(extra3)\n ➖➖➖➖➖➖➖ REQUEST ➖➖➖➖➖➖➖\n 🌐 URL: \(url)\n Ⓜ️ METHOD: \(method)\n 🔒 HEADER: \(header)\n 💾 CachePolicy: \(cachePolicy)\n ⏱ TimeInterval: \(timeInterval)\n 🔋 BODY: \(dataToString(body))\n")
        }
    }
    
    public func responseSuccess(_ data: Data,
                                extra1: String = #file,
                                extra2: String = #function,
                                extra3: Int = #line) {
        if Logger.isLoggingEnabled {
            let filename = (extra1 as NSString).lastPathComponent
            print(" \(LogEvent.success.rawValue)\n ⏰ Time: \(Date().toString())\n 📍 FileName: \(filename)\n 📍 Func: \(extra2)\n 📍 Line: \(extra3)\n ➖➖➖➖➖➖➖ RESPONSE ➖➖➖➖➖➖➖\n \(dataToString(data))\n")
        }
    }
    
    public func responseError(_ data: Data,
                              extra1: String = #file,
                              extra2: String = #function,
                              extra3: Int = #line) {
        if Logger.isLoggingEnabled {
            let filename = (extra1 as NSString).lastPathComponent
            print(" \(LogEvent.error.rawValue)\n ⏰ Time: \(Date().toString())\n 📍 FileName: \(filename)\n 📍 Func: \(extra2)\n 📍 Line: \(extra3)\n ➖➖➖➖➖➖➖ RESPONSE ➖➖➖➖➖➖➖\n \(dataToString(data))\n")
        }
    }
    
    public func debugPrint(_ message: Any,
                           extra1: String = #file,
                           extra2: String = #function,
                           extra3: Int = #line) {
        if Logger.isLoggingEnabled {
            let filename = (extra1 as NSString).lastPathComponent
            print(" \(LogEvent.warning.rawValue)\n ⏱ Time: \(Date().toString())\n 📍 FileName: \(filename)\n 📍 Func: \(extra2)\n 📍 Line: \(extra3)\n 🔊 DEBUG_INFO:\n \(message)")
        }
    }
    
    public func dumpPrint(_ message: Any) {
        dump(message)
    }
    
    public func printDocumentsDirectory() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print(" 🗄 Document Path: \(documentsPath)")
    }
    
    // MARK: - Flow internal funcs
    internal func print(_ object: Any) {
        // Only allowing in DEBUG mode
        #if DEBUG
        Swift.print(object)
        #endif
    }
    
    internal func dataToString(_ data: Data) -> String {
        //        let dict = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) ?? [:]
        //        let jsonDataAgain = (try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)) ?? Data()
        let jsonStringAgain = String(data: data, encoding: .ascii) ?? ""
        return jsonStringAgain
    }
    
    internal func dictToString(_ dict: [String:Any]) -> String {
        let jsonDataAgain = (try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)) ?? Data()
        let jsonStringAgain = String(data: jsonDataAgain, encoding: .ascii) ?? ""
        return jsonStringAgain
    }
}

// MARK: - Internal Extension for Date
internal extension Date {
    func toString() -> String {
        return Logger.dateFormatter.string(from: self as Date)
    }
}

// MARK: - Internal Extension for Collection
internal extension Collection {
    
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
