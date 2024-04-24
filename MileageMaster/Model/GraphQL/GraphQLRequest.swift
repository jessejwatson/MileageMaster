//
//  GraphQLRequest.swift
//  MileageMaster
//
//  Created by Jesse Watson on 23/04/2024.
//

import Foundation

class GraphQLRequest<T: Codable> {
    
    private var request: URLRequest
    private let token: String
    private let body: [String: Any]
    
    enum Value {
        case string(String)
        case optionalString(String?)
        case bool(Bool)
        case int(Int)
        case double(Double)
    }
        
    init(query: String, variables: [(key: String, value: Value)]) {
        self.request = URLRequest(url: URL(string: "https://api-ap-southeast-2.hygraph.com/v2/clllyik5v12cr01t7hiqagsdm/master")!)
        self.token = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6ImdjbXMtbWFpbi1wcm9kdWN0aW9uIn0.eyJ2ZXJzaW9uIjozLCJpYXQiOjE3MDAyNjUzNjQsImF1ZCI6WyJodHRwczovL2FwaS1hcC1zb3V0aGVhc3QtMi5oeWdyYXBoLmNvbS92Mi9jbGxseWlrNXYxMmNyMDF0N2hpcWFnc2RtL21hc3RlciIsIm1hbmFnZW1lbnQtbmV4dC5ncmFwaGNtcy5jb20iXSwiaXNzIjoiaHR0cHM6Ly9tYW5hZ2VtZW50LWFwLXNvdXRoZWFzdC0yLmh5Z3JhcGguY29tLyIsInN1YiI6ImM1NmZhODRmLTBjYjUtNDUxYi04Y2M2LWFjMmU3MzljMTBhZiIsImp0aSI6ImNscDNhM2ppeDIwYTgwMXRhZHYwNDFiazcifQ.PMgKfEdM2T5GQsDcHcdeHjAIgChjmJ31WGaTzAiZ5e_e6hqTLy9v6o_Vs4jPbIWUxRlK-vGHeK3w7uoBMk1bpGOHHd-rTkDE8ivYufVOvPD7iwzTY2U5ejeWPUrBmeTpwbrilj055gZ_V7zTq1yPLrb3QK67EeY9iTW6nby71ZLXPjDIuVDABotT1X0YgAEWlONqT145agRFf_c_Gr3PHSV80nwunx4vcRHgfNcksi2pqiKxaRpR5jtwQCYPr1X6G6AmZtteRjCXf6bFRvd_mIjvwofBDxvinX5suWIttLy1W7GOdZtn3YWA8IeaHKiHA68erKODd7Mjhr3szojVsEUfF86A7b8BPNTNZ5McQ2qbaM4zCVhQ-ZBfa0NJUD40AjFanUIMTII7t6gyZtHGtXd4zGWUGyZ6hCQHZs52lOed-ya4rcWoWH79-tZHKR0PiI3KSoYAgLnSjrZse7W_1qevU0F3Th-xPZuU5CANMtvoCHx9AiGcP_vJZbbSBOBpWDTWV4atfI3sZhjAPvuq5My73onIpUqUyq2dQ2hsvBn0JsN2uez3uDqnIssJvclGh0FSbOl5hvvUefRqFIqiI1yBuOHgYcGWufhxF35oi3L6zXrulRUmjA8_Lv4FWp2YvH5BMiXcmPyOomdur-QhgX82w496E_fm4-Ddb6ZsgFo"
        
        let variablesDictionary = Dictionary(uniqueKeysWithValues: variables).mapValues { value -> Any in
            switch value {
            case .string(let stringValue):
                return stringValue
            case .optionalString(let stringOptionalValue):
                return stringOptionalValue ?? NSNull()
            case .bool(let boolValue):
                return boolValue
            case .int(let intValue):
                return intValue
            case .double(let doubleValue):
                return doubleValue
            }
        }
        
        self.body = [
            "query": query,
            "variables": variablesDictionary
        ]
    }
    
    func run() async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
                request.httpBody = jsonData
            } catch {
                print("Error: Unable to encode JSON body")
            }
            
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode), let data = data else {
                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                    continuation.resume(throwing: NSError(domain: "", code: (response as? HTTPURLResponse)?.statusCode ?? 0, userInfo: nil))
                    return
                }
                
                do {
                    let jsonResponse = try JSONDecoder().decode(T.self, from: data)
                    continuation.resume(returning: jsonResponse)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
            
            task.resume()
            
        }
    }
    
}
