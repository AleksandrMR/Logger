import Foundation

public class Logger {
    
    public static let shared = Logger()
    
    public init(){}
    
    public func debugPrint(_ message: Any,
                           extra1: String = #file,
                           extra2: String = #function,
                           extra3: Int = #line) {
        
        let filename = (extra1 as NSString).lastPathComponent
        print("[⚠️]", "[\(filename) \(extra3) line]", message)
    }
    
    /// pretty print
    public func requestPrint(_ data: Data) {
        
        
        
//        let data = request.data(using: .utf8) ?? Data()
        let dict = (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)) ?? [:]

        let jsonDataAgain = (try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)) ?? Data()
        let jsonStringAgain = String(data: jsonDataAgain, encoding: .utf8) ?? ""
        print(jsonStringAgain)
        
        
//        print("\nHTTP request: \(request.url?.absoluteString ?? "")\nParams: \(request.httpBody?.json() ?? "")\n")
    }
    
    public func dumpPrint(_ message: Any) {
        dump(message)
    }
    
    public func printDocumentsDirectory() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print("Document Path: \(documentsPath)")
    }
}

public extension Collection {
    
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
