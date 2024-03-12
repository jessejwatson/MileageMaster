//
//  GraphQLOperation.swift
//  MileageMaster
//
//  Created by Jesse Watson on 12/03/2024.
//

import Foundation

struct GraphQLOperation : Encodable
{
    var operationString: String
    
    private let url = URL(string: "https://api-ap-southeast-2.hygraph.com/v2/clllyik5v12cr01t7hiqagsdm/master")!
    private let apiKey = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6ImdjbXMtbWFpbi1wcm9kdWN0aW9uIn0.eyJ2ZXJzaW9uIjozLCJpYXQiOjE3MDAyNjUzNjQsImF1ZCI6WyJodHRwczovL2FwaS1hcC1zb3V0aGVhc3QtMi5oeWdyYXBoLmNvbS92Mi9jbGxseWlrNXYxMmNyMDF0N2hpcWFnc2RtL21hc3RlciIsIm1hbmFnZW1lbnQtbmV4dC5ncmFwaGNtcy5jb20iXSwiaXNzIjoiaHR0cHM6Ly9tYW5hZ2VtZW50LWFwLXNvdXRoZWFzdC0yLmh5Z3JhcGguY29tLyIsInN1YiI6ImM1NmZhODRmLTBjYjUtNDUxYi04Y2M2LWFjMmU3MzljMTBhZiIsImp0aSI6ImNscDNhM2ppeDIwYTgwMXRhZHYwNDFiazcifQ.PMgKfEdM2T5GQsDcHcdeHjAIgChjmJ31WGaTzAiZ5e_e6hqTLy9v6o_Vs4jPbIWUxRlK-vGHeK3w7uoBMk1bpGOHHd-rTkDE8ivYufVOvPD7iwzTY2U5ejeWPUrBmeTpwbrilj055gZ_V7zTq1yPLrb3QK67EeY9iTW6nby71ZLXPjDIuVDABotT1X0YgAEWlONqT145agRFf_c_Gr3PHSV80nwunx4vcRHgfNcksi2pqiKxaRpR5jtwQCYPr1X6G6AmZtteRjCXf6bFRvd_mIjvwofBDxvinX5suWIttLy1W7GOdZtn3YWA8IeaHKiHA68erKODd7Mjhr3szojVsEUfF86A7b8BPNTNZ5McQ2qbaM4zCVhQ-ZBfa0NJUD40AjFanUIMTII7t6gyZtHGtXd4zGWUGyZ6hCQHZs52lOed-ya4rcWoWH79-tZHKR0PiI3KSoYAgLnSjrZse7W_1qevU0F3Th-xPZuU5CANMtvoCHx9AiGcP_vJZbbSBOBpWDTWV4atfI3sZhjAPvuq5My73onIpUqUyq2dQ2hsvBn0JsN2uez3uDqnIssJvclGh0FSbOl5hvvUefRqFIqiI1yBuOHgYcGWufhxF35oi3L6zXrulRUmjA8_Lv4FWp2YvH5BMiXcmPyOomdur-QhgX82w496E_fm4-Ddb6ZsgFo"
    
    enum CodingKeys: String, CodingKey
    {
        case variables
        case query
    }
    
    init(_ operationString: String)
    {
        self.operationString = operationString
    }

    func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(operationString, forKey: .query)
    }
    
    func getURLRequest() throws -> URLRequest
    {
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONEncoder().encode(self)
    
        return request
    }
}
