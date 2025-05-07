
import CocoaLumberjack
import Foundation

struct ZQ {
    class Formatter: NSObject, DDLogFormatter {
        private let dateFormatter: DateFormatter
        private var enableTime = true
        init(_ df: DateFormatter? = nil, enableTime: Bool = true) {
            if let df = df {
                dateFormatter = df
            }else{
                dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
            }
            self.enableTime = enableTime
         }
        
        func format(message logMessage: DDLogMessage) -> String? {
            let flag: String = switch logMessage.flag {
                case .error:    "E"
                case .warning:  "W"
                case .debug:    "D"
                case .info:     "I"
                default:        "V"
            }
            if enableTime {
                let time = dateFormatter.string(from: logMessage.timestamp)
                return "\(time) | \(flag) | \(logMessage.message)"
            }
            return "App | \(flag) | \(logMessage.message)"
        }
    }
    
    struct Logger {
        /// 日志配置
        static func setup() {
            let osLogger = DDOSLogger.sharedInstance
            osLogger.logFormatter = ZQ.Formatter(enableTime: false)
            DDLog.add(osLogger)
            let fileLogger = DDFileLogger()
            fileLogger.rollingFrequency = 60 * 60 * 24 // 24 hours
            fileLogger.logFileManager.maximumNumberOfLogFiles = 7
            fileLogger.logFormatter = ZQ.Formatter()
            DDLog.add(fileLogger, with: .warning)
        }
        
        static func verbose(_ message: @autoclosure () -> DDLogMessageFormat,
                            level: DDLogLevel = DDDefaultLogLevel,
                            context: Int = 0,
                            file: StaticString = #file,
                            function: StaticString = #function,
                            line: UInt = #line,
                            tag: Any? = nil,
                            asynchronous: Bool = asyncLoggingEnabled,
                            ddlog: DDLog = .sharedInstance) {
            DDLogVerbose(message(),
                       level: level,
                       context: context,
                       file: file,
                       function: function,
                       line: line,
                       tag: tag,
                       asynchronous: asynchronous,
                       ddlog: ddlog)
        }
        static func debug(_ message: @autoclosure () -> DDLogMessageFormat,
                          level: DDLogLevel = DDDefaultLogLevel,
                          context: Int = 0,
                          file: StaticString = #file,
                          function: StaticString = #function,
                          line: UInt = #line,
                          tag: Any? = nil,
                          asynchronous: Bool = asyncLoggingEnabled,
                          ddlog: DDLog = .sharedInstance) {
            DDLogDebug(message(),
                       level: level,
                       context: context,
                       file: file,
                       function: function,
                       line: line,
                       tag: tag,
                       asynchronous: asynchronous,
                       ddlog: ddlog)
        }
        
        static func info(_ message: @autoclosure () -> DDLogMessageFormat,
                         level: DDLogLevel = DDDefaultLogLevel,
                         context: Int = 0,
                         file: StaticString = #file,
                         function: StaticString = #function,
                         line: UInt = #line,
                         tag: Any? = nil,
                         asynchronous: Bool = asyncLoggingEnabled,
                         ddlog: DDLog = .sharedInstance) {
            DDLogInfo(message(),
                      level: level,
                      context: context,
                      file: file,
                      function: function,
                      line: line,
                      tag: tag,
                      asynchronous: asynchronous,
                      ddlog: ddlog)
        }
        
        static func warn(_ message: @autoclosure () -> DDLogMessageFormat,
                         level: DDLogLevel = DDDefaultLogLevel,
                         context: Int = 0,
                         file: StaticString = #file,
                         function: StaticString = #function,
                         line: UInt = #line,
                         tag: Any? = nil,
                         asynchronous: Bool = asyncLoggingEnabled,
                         ddlog: DDLog = .sharedInstance) {
            DDLogWarn(message(),
                      level: level,
                      context: context,
                      file: file,
                      function: function,
                      line: line,
                      tag: tag,
                      asynchronous: asynchronous,
                      ddlog: ddlog)
        }
        
        static func error(_ message: @autoclosure () -> DDLogMessageFormat,
                          level: DDLogLevel = DDDefaultLogLevel,
                          context: Int = 0,
                          file: StaticString = #file,
                          function: StaticString = #function,
                          line: UInt = #line,
                          tag: Any? = nil,
                          asynchronous: Bool = false,
                          ddlog: DDLog = .sharedInstance) {
            DDLogError(message(),
                       level: level,
                       context: context,
                       file: file,
                       function: function,
                       line: line,
                       tag: tag,
                       asynchronous: asynchronous,
                       ddlog: ddlog)
        }
    }
    
   
}
typealias Logger = ZQ.Logger

/*使用示例
 Logger.verbose("Verbose")
 Logger.debug("Debug")
 Logger.info("Info")
 Logger.warn("Warn")
 Logger.error("Error")
 */
