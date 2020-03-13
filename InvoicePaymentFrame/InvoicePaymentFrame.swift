//
//  InvoicePaymentFrame.swift
//  InvoicePaymentFrame
//
//  Created by Kirill Kuznetsov on 13/03/2020.
//  Copyright © 2020 Invoice LLC. All rights reserved.
//

import Foundation
import WebKit

protocol PaymentCallback {
    func onSuccess(status: InvoiceTransaction)
    func onError(status: InvoiceTransaction)
    func onOtherStatus(status: InvoiceTransaction)
}

protocol InvoiceAPICallback {
    func onComplete(data: InvoiceTransaction);
}

struct InvoiceTransaction: Codable {
    var id: String?
    var amount: String?
    var amountbonus: String?
    var statusNum: String?
    var statusMsg: String?
    var bonus_gift: String?
}

struct PaymentStatus{
    private struct StatusRequest: Encodable {
        public var id: String?;
    }
    
    private struct StatusResponse: Decodable {
        var transaction: InvoiceTransaction;
    }
    
    private var statusUrl: String = "https://backend.invoice.su/api/customers.payStatus";
    private var callback: InvoiceAPICallback?;
    
    init(callback: InvoiceAPICallback) {
        self.callback = callback;
    }
    
    public func get(id: String) {
        let statusRequest = StatusRequest(id: id);
        let payload = try! JSONEncoder().encode(statusRequest)
        
        let url = URL(string: self.statusUrl)!;
        var request = URLRequest(url: url);
        
        request.httpMethod = "POST";
        request.httpBody = payload;
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else { return }
        
            self.complete(data: data)
        }
        task.resume();
    }
    
    private func complete(data: Data) {
        let status = try! JSONDecoder().decode(StatusResponse.self, from: data)
        let transtaction = status.transaction;
        callback?.onComplete(data: transtaction)
    }
    
}

class PaymentFrame: WKWebView {
    
    private var baseUrl: String = "https://pay.invoice.su/P";
    private var paymentCallback: PaymentCallback?;
    private var paymentId: String = "";
    private var paymentIsComplete: Bool = false;
    
    public func goPay(paymentId: String) {
        self.paymentId = paymentId;
        startHandler();
        
        let url = URL(string: baseUrl + paymentId)
        self.load(URLRequest(url: url!))
    }
    
    public func setPaymentCallback(callback: PaymentCallback) -> PaymentFrame{
        self.paymentCallback = callback;
        
        return self;
    }
    
    private func startHandler() {
        DispatchQueue.global(qos: .background).async {
            
            var startUrl: String = "";
            
            DispatchQueue.main.async {
                startUrl = self.url?.absoluteString ?? "nil";
            }
            
            
            while !self.paymentIsComplete {
                if self.paymentIsComplete {
                    break;
                }
                if(startUrl == "nil") {
                    continue;
                }
                
                var url: String = ""
                DispatchQueue.main.async {
                    url = self.url?.absoluteString ?? "nil";
                }
                
                if url != startUrl {
                    DispatchQueue.main.async {
                        self.onRedirect(url: url)
                    }
                    
                }
                
            }
            
        }
        
    }
    
    public func stopHandler() {
        self.paymentIsComplete = true;
    }
    
    private func onRedirect(url: String) {
        if(paymentIsComplete) {
            return;
        }
        
        if url == "nil" {
            return;
        }
        
        if !url.contains("https://pay.invoice.su") {
            goBack();
            return;
        }
        
        if url.contains("https://pay.invoice.su/status/") {
            paymentIsComplete = true;
            onRequestResult();
            return;
        }
    }
    
    private func onRequestResult() {
        class InvoiceAPICallbackImpl: InvoiceAPICallback {
            var context: PaymentFrame?;
            
            func onComplete(data: InvoiceTransaction) {
                switch data.statusNum {
                case "2":
                    DispatchQueue.main.async(execute: {
                        self.context?.paymentCallback?.onSuccess(status: data)
                     })
                    break
                case "6":
                    DispatchQueue.main.async(execute: {
                        self.context?.paymentCallback?.onError(status: data)
                    })
                    break
                default:
                    DispatchQueue.main.async(execute: {
                        self.context?.paymentCallback?.onOtherStatus(status: data)
                    })
                    break
                }
            }
        }
        let callback = InvoiceAPICallbackImpl();
        callback.context = self;
        
        let status = PaymentStatus(callback: callback);
        status.get(id: paymentId)
    }
}
