//
//  NetworkManager.swift
//  HelloWorldClient
//
//  Created by Barry Ma on 2023-09-08.
//

import Foundation
import Combine
import OSLog

class APIManager: NSObject {
    static let shared = APIManager()
    private var session: URLSession?
    
    override init() {
        super.init()
        self.session = URLSession(configuration: .default,
                                  delegate: self,
                                  delegateQueue: nil)
    }
    
    /// Builds the relevant URL components from the values specified in the API.
    private func buildURL(endpoint: API) -> URLComponents {
        var components = URLComponents()
        components.scheme = endpoint.scheme.rawValue
        components.host = endpoint.baseURL
        components.path = endpoint.path

        if !endpoint.parameters.isEmpty {
            components.queryItems = endpoint.parameters
        }

        return components
    }
    
    /// Executes the HTTP request and will attempt to decode the JSON
    /// response into a Codable object.
    /// - Parameter endpoint: an endpoint to make the HTTP request to
    /// - Returns: a publisher delivers data in provided Decodable type when successful or an APIError when failed
    func request<T: Decodable>(endpoint: API) -> AnyPublisher<T, APIError> {
        let authManager = AuthManager()
        let components = buildURL(endpoint: endpoint)
        
        return authManager.getToken()
            .flatMap { token -> AnyPublisher<T, APIError> in
                guard let url = components.url else {
                    Logger.networking.error("❌ Failed to create URL.")
                    return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
                }
                
                Logger.networking.info("➡️ Initiate HTTP Request to endpoint: \(url)")
                
                var urlRequest = URLRequest(url: url)
                urlRequest.httpMethod = endpoint.method.rawValue
                urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
                
                return self.session!
                    .dataTaskPublisher(for: urlRequest)
                    .tryMap({ data, response in
                        if let statusCode = (response as? HTTPURLResponse)?.statusCode,
                              statusCode < 200 || statusCode > 299 {
                            Logger.networking.error("❌ Server-side error with status code \(statusCode)")
                            throw APIError.serverSideError(statusCode)
                        }
                        return data
                    })
                    .decode(type: T.self, decoder: JSONDecoder())
                    .retry(3)
                    .receive(on: DispatchQueue.main)
                    .mapError { error -> APIError in
                        switch error {
                        case _ as DecodingError:
                            Logger.networking.error("❌ Failed to parse response")
                            return .invalidJson(String(describing: T.self))
                        default:
                            Logger.networking.error("❌ Network error: \(error.localizedDescription)")
                            return .transportError(error)
                        }
                    }
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

/// SSL Pinning
extension APIManager: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        /// Make sure we have received the certificate
        guard let trust = challenge.protectionSpace.serverTrust,
              SecTrustGetCertificateCount(trust) > 0,
              let remoteCerts = SecTrustCopyCertificateChain(trust) as? [SecCertificate],
              remoteCerts.count > 0 else {
            Logger.networking.error("❌ No SSL certificate is found")
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        
        /// Get data of both certificates
        let remoteCertData = SecCertificateCopyData(remoteCerts[0]) as Data
        let pathToLocalCert = Bundle.main.path(forResource: "hiring.iverify.io", ofType: "cer")
        let localCertData = NSData(contentsOfFile: pathToLocalCert!)!
        
        /// Compare certificates
        if localCertData.isEqual(to: remoteCertData) {
            Logger.networking.info("✅ SSL Pinning succeed")
            completionHandler(.useCredential, nil)
            return
        }
        
        Logger.networking.error("❌ SSL Pinning failed")
        completionHandler(.cancelAuthenticationChallenge, nil)
    }
}
