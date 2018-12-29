import Foundation

struct Logger {
    private static let enabled = true

    static func log(_ closure: @autoclosure () -> Any) {
        if enabled { NSLog("\(closure())") }
    }
}
