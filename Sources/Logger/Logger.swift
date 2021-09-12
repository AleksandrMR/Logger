
import UIKit

enum LogType: String {
    case info    = "💡 INFO"
    case debug   = "⚙️ DEBUG"
}

public enum LogEvent: String {
    case error   = "🔴 ERROR"
    case warning = "🟡 WARNING"
    case success = "🟢 SUCCESS"
    case message = "✉️ MESSAGE"
}

public class Logger {
    
    // MARK: - Let
    public static let shared = Logger()
    private let date = Date().toString()
    private let separator = "➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖"
    
    private init(){}
    
    // MARK: - Var
    private var noValue = "None"
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
    public func printURLRequest(_ urlRequest: URLRequest?,
                                logEvent: LogEvent,
                                extra1: String = #file,
                                extra2: String = #function,
                                extra3: Int = #line) {
        if Logger.isLoggingEnabled {
            let filename = (extra1 as NSString).lastPathComponent
            let myLogEvent = logEvent.rawValue
            let url = urlRequest?.url?.absoluteString ?? noValue
            let method = urlRequest?.httpMethod ?? noValue
            let cachePolicy = urlRequest?.cachePolicy.hashValue ?? 0
            let timeInterval = urlRequest?.timeoutInterval ?? 0
            let header = dictToString(urlRequest?.allHTTPHeaderFields)
            let body = dataToString(urlRequest?.httpBody)
            print("\n\n ⏰ \(date)\n \(separator) ⁉️ REQUEST\n 📍 FileName: \(filename)\n 📍 Func: \(extra2)\n 📍 Line: \(extra3)\n \(separator) \(myLogEvent)\n 🌐 URL: \(url)\n Ⓜ️ METHOD: \(method)\n 🔒 HEADER: \(header)\n 📀 CachePolicy: \(cachePolicy)\n ⏱ TimeInterval: \(timeInterval)\n 🛢 BODY: \(body)\n \(separator) ‼️ END ‼️ \n\n")
        }
    }
    
    public func printeURLResponse(_ response: HTTPURLResponse?,
                                  _ data: Data?,
                                  logEvent: LogEvent,
                                  extra1: String = #file,
                                  extra2: String = #function,
                                  extra3: Int = #line) {
        if Logger.isLoggingEnabled {
            let filename = (extra1 as NSString).lastPathComponent
            let myLogEvent = logEvent.rawValue
            let url = response?.url?.absoluteString ?? noValue
            let statusCode = response?.statusCode ?? 0
            let header = dictToString(response?.allHeaderFields)
            let body = dataToString(data)
            print("\n\n ⏰ \(date)\n \(separator) ‼️ RESPONSE\n 📍 FileName: \(filename)\n 📍 Func: \(extra2)\n 📍 Line: \(extra3)\n \(separator) \(myLogEvent)\n 🌐 URL: \(url)\n ⚠️ STATUS_CODE: \(statusCode)\n 🔒 HEADER: \(header)\n 🛢 BODY: \(body)\n \(separator) ‼️ END ‼️ \n\n")
        }
    }
    
    public func printDebug(_ message: Any,
                           logEvent: LogEvent,
                           extra1: String = #file,
                           extra2: String = #function,
                           extra3: Int = #line) {
        if Logger.isLoggingEnabled {
            let filename = (extra1 as NSString).lastPathComponent
            let eventType = LogType.debug.rawValue
            let myLogEvent = logEvent.rawValue
            var title = "MESSAGE"
            if myLogEvent == LogEvent.message.rawValue {
                title = ""
            }
            print("\n\n ⏰ \(date)\n \(separator) \(eventType)\n 📍 FileName: \(filename)\n 📍 Func: \(extra2)\n 📍 Line: \(extra3)\n \(separator) \(myLogEvent) \(title)\n\n \(message)\n\n \(separator) ‼️ END ‼️ \n\n")
        }
    }
    
    public func printImageBytes(image: UIImage?,
                                data: Data?,
                                extra1: String = #file,
                                extra2: String = #function,
                                extra3: Int = #line) {
        if Logger.isLoggingEnabled {
            var imageData: Data?
            let filename = (extra1 as NSString).lastPathComponent
            let eventType = LogType.info.rawValue
            
            if image != nil {
                imageData = image?.jpegData(compressionQuality: 1.0)
            } else if data != nil {
                imageData = data
            }
            
            if let imageSize = imageData?.count {
                let message = "actual size of image in KB: \(Double(imageSize) / 1000.0)"
                print("\n\n ⏰ \(date)\n \(separator) \(eventType)\n 📍 FileName: \(filename)\n 📍 Func: \(extra2)\n 📍 Line: \(extra3)\n \(separator) ✉️ MESSAGE\n \(message)\n \(separator) ‼️ END ‼️ \n\n")
            }
        }
    }
    
    public func printDumpMod(_ message: Any) {
        dump(message)
    }
    
    public func printDocumentDirectory(extra1: String = #file,
                                       extra2: String = #function,
                                       extra3: Int = #line) {
        let eventType = LogType.info.rawValue
        let filename = (extra1 as NSString).lastPathComponent
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print("\n\n \(separator) \(eventType)\n 📍 FileName: \(filename)\n 📍 Func: \(extra2)\n 📍 Line: \(extra3)\n \(separator) 🌍 DOCUMENT PATH\n \(documentPath)\n \(separator) ‼️ END ‼️ \n\n")
    }
    
    // MARK: - Flow internal funcs
    func print(_ object: Any) {
        // print object only in DEBUG mode
        #if DEBUG
        Swift.print(object)
        #endif
    }
    
    func dataToString(_ data: Data?) -> String {
        if data != nil {
            let myData = data ?? Data()
            let dict = (try? JSONSerialization.jsonObject(with: myData, options: .allowFragments)) ?? [:]
            let jsonDataAgain = (try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)) ?? Data()
            let jsonString = String(decoding: jsonDataAgain, as: UTF8.self)
            return jsonString
        } else {
            return noValue
        }
    }
    
    func dictToString(_ dict: [AnyHashable:Any]?) -> String {
        if dict != nil {
            let myDict = dict ?? [AnyHashable:Any]()
            let data = (try? JSONSerialization.data(withJSONObject: myDict, options: .prettyPrinted)) ?? Data()
            let jsonString = String(data: data, encoding: .ascii) ?? noValue
            return jsonString
        } else {
            return noValue
        }
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
