import Foundation
import Promises

final class NetworkingService {
    private let basePath = "http://localhost:8080/"

    private let http: RequestExecutor
    private var headers = [String: String]()


    init(requestExecutor: RequestExecutor) {
        http = requestExecutor
        headers["Content-Type"] = "application/json"
    }

    func get(path: String) -> Promise<Data> {
        let fullPath = basePath + path
        return http.perform(path: fullPath, method: .get, headers: headers, body: nil)
    }

    func post(path: String, body: Data) -> Promise<Data> {
        let fullPath = basePath + path
        return http.perform(path: fullPath, method: .post, headers: headers, body: body)
    }
}
