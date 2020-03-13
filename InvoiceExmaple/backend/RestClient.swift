//
//  RestClient.swift
//  InvoiceExmaple
//
//  Created by Кирилл Кузнецов on 12/03/2020.
//  Copyright © 2020 Invoice LLC. All rights reserved.
//

import Foundation

class RestClient {
    
    private var login: String = "demo";
    private var apiKey: String  = "1526fec01b5d11f4df4f2160627ce351";
    public var url: String = "https://api.invoice.su/api/v2/";
    public var callback: RequestCallback;
    
    init(login: String, apiKey: String, callback: RequestCallback) {
        self.apiKey = apiKey;
        self.login = login;
        self.callback = callback;
    }
    
    init(callback: RequestCallback) {
        self.callback = callback;
    }
    
    private func HttpsRequest(url: String, method: String, payload: Data) {
        let url = URL(string: url)!;
        var request = URLRequest(url: url);
        
        request.httpMethod  = method;
        request.httpBody = payload;
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic "+getAuthString(), forHTTPHeaderField: "Authorization")
    
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                self.callback.onError(error: error)
            }
            
            guard let data = data else { return }
            
            DispatchQueue.main.async(execute: {
                self.callback.onSuccess(data: data)
             })
            
        }
        task.resume();
    }
    
    private func getAuthString() -> String{
        let authStr = self.login+":"+self.apiKey
        
        return authStr.data(using: .utf8)?.base64EncodedString() ?? "";
    }
    
    public func request(createTerminal: CreateTerminal) {
        let payload = try! JSONEncoder().encode(createTerminal)
        HttpsRequest(url: self.url+"CreateTerminal", method: "POST", payload: payload)
    }
    
    public func request(createPayment: CreatePayment) {
        let payload = try! JSONEncoder().encode(createPayment)
        HttpsRequest(url: self.url+"CreatePayment", method: "POST", payload: payload)
    }
    
}
