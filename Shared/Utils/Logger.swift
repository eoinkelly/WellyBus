import os.log

private let logSubSystem = "info.eoinkelly.WellyBus"

private let genericLog = Logger(subsystem: logSubSystem, category: "Generic")
private let metlinkApiLog = Logger(subsystem: logSubSystem, category: "MetlinkAPI")
private let serviceLog = Logger(subsystem: logSubSystem, category: "Services")
private let mainAppLog = Logger(subsystem: logSubSystem, category: "MainApp")
private let widgetLog = Logger(subsystem: logSubSystem, category: "Widget")

enum AppLogger {
  case generic
  case metlinkApi
  case service
  case mainApp
  case widget
}

struct Log {
  static func error(_ message: String, logger: AppLogger = .generic) {
    log(message, logger: logger, level: .error)
  }

  static func notice(_ message: String, logger: AppLogger = .generic) {
    log(message, logger: logger, level: .default)
  }

  static func log(_ message: String, logger: AppLogger = .generic, level: OSLogType = .`default`) {
    switch logger {
    case .generic: genericLog.log(level: level, "\(message, privacy: .public)")
    case .metlinkApi: metlinkApiLog.log(level: level, "\(message, privacy: .public)")
    case .service: serviceLog.log(level: level, "\(message, privacy: .public)")
    case .mainApp: mainAppLog.log(level: level, "\(message, privacy: .public)")
    case .widget: widgetLog.log(level: level, "\(message, privacy: .public)")
    }

    // The "Previews" log stream in XCode does not show logger messages when re-rendering a Preview so
    // we print log messages to stdout to keep things handy
    #if targetEnvironment(simulator)
      let logLevelName =
        switch level {
        case .debug: "DEBUG"
        case .`default`: "NOTICE"
        case .error: "ERROR"
        case .fault: "FAULT"
        case .info: "INFO"
        default: "UNMAPPED"
        }

      print("\(logLevelName): \(logger): \(message)")
    #endif

  }
}
