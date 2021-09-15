
import UIKit

/// Description for LogType
public enum LogType: String {
    case info     = "💡 INFO"
    case debug    = "⚙️ DEBUG"
    case request  = "⁉️ REQUEST"
    case response = "‼️ RESPONSE"
}

/// Description for LogEvent
public enum LogEvent: String {
    case error   = "🔴 ERROR"
    case warning = "🟡 WARNING"
    case success = "🟢 SUCCESS"
    case message = "✉️ MESSAGE"
}

/// Description for Loggable
public protocol Loggable {
    func getLogInfo() -> String
}

/// Description for Logger
public class Logger {
    
    // MARK: - Let
    public static let shared = Logger()
    
    // LogElements
    static let url          = "\n 🌐 URL:"
    static let method       = "\n Ⓜ️ METHOD:"
    static let header       = "\n 🔒 HEADER:"
    static let cachePolicy  = "\n 📀 CachePolicy:"
    static let timeInterval = "\n ⏱ TimeInterval:"
    static let statusCode   = "\n ⚠️ STATUS_CODE:"
    static let body         = "\n 🛢 BODY:"
    static let noValue      = "🚫 None"
    private let date        = "\n\n ⏰ \(Date().toString())\n"
    private let fileName    = "\n📍 FileName:"
    private let logFunc     = "\n📍 Func:"
    private let logLine     = "\n📍 Line:"
    private let end         = "‼️ END ‼️ \n\n"
    private let separator   = "➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖➖"
    
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
    public func printLog(_ obj: Loggable,
                         _ data: Loggable? = nil,
                         _ logType: LogType,
                         _ logEvent: LogEvent,
                         extra1: String = #file,
                         extra2: String = #function,
                         extra3: Int = #line) {
        if Logger.isLoggingEnabled {
            let filename = (extra1 as NSString).lastPathComponent
            let myLogType = logType.rawValue
            let myLogEvent = logEvent.rawValue
            let fileLocation = "\(fileName) \(filename) \(logFunc) \(extra2) \(logLine) \(extra3)"
            var body = ""
            if data != nil {
                body = data?.getLogInfo() ?? ""
            }
            print("\(date) \(separator) \(myLogType) \(fileLocation)\n \(separator) \(myLogEvent) \(obj.getLogInfo())\(body)\n \(separator) \(end)")
        }
    }
    
    /// Description for printImageBytes
    /// - Parameters:
    ///   - image: image description
    ///   - data: data description
    ///   - extra1: extra1 description
    ///   - extra2: extra2 description
    ///   - extra3: extra3 description
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
    
    /// Description for printDumpMod
    /// - Parameter message: message description
    public func printDumpMod(_ message: Any) {
        dump(message)
    }
    
    /// Description for printDocumentDirectory
    /// - Parameters:
    ///   - extra1: extra1 description
    ///   - extra2: extra2 description
    ///   - extra3: extra3 description
    public func printDocumentDirectory(extra1: String = #file,
                                       extra2: String = #function,
                                       extra3: Int = #line) {
        let eventType = LogType.info.rawValue
        let filename = (extra1 as NSString).lastPathComponent
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print("\n\n \(separator) \(eventType)\n 📍 FileName: \(filename)\n 📍 Func: \(extra2)\n 📍 Line: \(extra3)\n \(separator) 🌍 DOCUMENT PATH\n \(documentPath)\n \(separator) ‼️ END ‼️ \n\n")
    }
    
    // MARK: - Flow internal funcs
    private func print(_ object: Any) {
        // print object only in DEBUG mode
        #if DEBUG
        Swift.print(object)
        #endif
    }
    
    static func dataToString(_ data: Data?) -> String {
        if data != nil {
            let myData = data ?? Data()
            let dict = (try? JSONSerialization.jsonObject(with: myData, options: .allowFragments)) ?? [:]
            let jsonDataAgain = (try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)) ?? Data()
            let jsonString = String(decoding: jsonDataAgain, as: UTF8.self)
            return jsonString
        } else {
            return Logger.noValue
        }
    }
    
    static func dictToString(_ dict: [AnyHashable:Any]?) -> String {
        if dict != nil {
            let myDict = dict ?? [AnyHashable:Any]()
            let data = (try? JSONSerialization.data(withJSONObject: myDict, options: .prettyPrinted)) ?? Data()
            let jsonString = String(data: data, encoding: .ascii) ?? Logger.noValue
            return jsonString
        } else {
            return Logger.noValue
        }
    }
}
