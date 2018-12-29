import Foundation
import Promises

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
}

enum RequestExecutorError: Error {
    case failedToFormURL
    case missingSelf
    case didNotReceiveUrlHttpResponse
    case unauthorized
    case clientError
    case serverError
    case unknownError
}

protocol RequestExecutor {
    func perform(path: String,
                 method: RequestMethod,
                 headers: [String: String],
                 body: Data?) -> Promise<Data>
}

final class HttpRequestExecutor: RequestExecutor {
    private typealias DidRequestSucceed = (wasSuccess: Bool, failureError: Error?)
    private let session = URLSession.shared

    func perform(path: String,
                 method: RequestMethod,
                 headers: [String: String],
                 body: Data?) -> Promise<Data> {
        let log = "Performing \(method.rawValue) " +
        "at: \(path)\n with body: \(String(data: body ?? Data(), encoding: .utf8) ?? "nil")"
        Logger.log(log)

        return Promise { [weak self] fullfill, reject in
            guard let strongSelf = self else { throw RequestExecutorError.missingSelf }

            let request = try strongSelf.constructRequest(
                path: path,
                method: method,
                headers: headers,
                body: body
            )

            let task = try strongSelf.constructTask(
                request: request,
                fullfill: fullfill,
                reject: reject
            )

            task.resume()
        }
    }

    private func constructRequest(path: String,
                                  method: RequestMethod,
                                  headers: [String: String],
                                  body: Data?) throws -> URLRequest {
        guard let url = URL(string: path) else { throw RequestExecutorError.failedToFormURL }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        headers.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        return request
    }

    private func constructTask(request: URLRequest,
                               fullfill: @escaping (Data) -> Void,
                               reject: @escaping (Error) -> Void) throws -> URLSessionTask {
        return session.dataTask(with: request) { [weak self] data, response, error in

            DispatchQueue.main.async { [weak self] in
                self?.resolveRequest(fullfill: fullfill,
                                     reject: reject,
                                     data: data,
                                     response: response,
                                     error: error)
            }
        }
    }

    private func resolveRequest(fullfill: @escaping (Data) -> Void,
                                reject: @escaping (Error) -> Void,
                                data: Data?,
                                response: URLResponse?,
                                error: Error?) {
        let didRequestSucceed = self.didRequestSucceed(response: response)

        if !didRequestSucceed.wasSuccess,
            let requestError = didRequestSucceed.failureError {
            reject(requestError)
            return
        }

        if let error = error {
            reject(error)
            return
        }

        if let data = data {
            fullfill(data)
            return
        }
    }

    private func didRequestSucceed(response urlResponse: URLResponse?) -> DidRequestSucceed {
        guard let response = urlResponse as? HTTPURLResponse else {
            return (false, RequestExecutorError.didNotReceiveUrlHttpResponse)
        }

        switch response.statusCode {
        case 100 ..< 200: return (true, nil) // Informational
        case 200 ..< 300: return (true, nil) // Success
        case 300 ..< 400: return (true, nil) // Redirection
        case 401: return (false, RequestExecutorError.unauthorized)
        case 401 ..< 500: return (false, RequestExecutorError.clientError)
        case 500 ..< 600: return (false, RequestExecutorError.serverError)
        default: return (false, RequestExecutorError.unknownError)
        }
    }
}
