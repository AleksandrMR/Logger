import Foundation

public class Logger {
    
    public static let shared = Logger()
        
        public init(){}
    
    public func debugPrint(
        _ message: Any,
        extra1: String = #file,
        extra2: String = #function,
        extra3: Int = #line,
        remoteLog: Bool = false,
        plain: Bool = false
    ) {
        if plain {
            print(message)
        }
        else {
            let filename = (extra1 as NSString).lastPathComponent
            print(message, "[\(filename) \(extra3) line]")
        }
        
        // if remoteLog is true record the log in server
        if remoteLog {
            //            if let msg = message as? String {
            //                logEvent(msg, event: .error, param: nil)
            //            }
        }
    }
    
    /// pretty print
    public func prettyPrint(_ message: Any) {
        dump(message)
    }
    
    public func printDocumentsDirectory() {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        print("Document Path: \(documentsPath)")
    }
}
