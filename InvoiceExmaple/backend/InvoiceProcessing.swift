//
//  InvoiceProcessing.swift
//  InvoiceExmaple
//
//  Created by Кирилл Кузнецов on 12/03/2020.
//  Copyright © 2020 Invoice LLC. All rights reserved.
//

import Foundation

class InvoiceProcessing {
    
    public var login: String = "demo";
    public var apiKey: String = "1526fec01b5d11f4df4f2160627ce351";
    public var terminalId: String = "b88c719946e01b1396ba3724d634982c";
    
    private var callback: RequestCallback;
    private var client: RestClient;
    
    init(callback: RequestCallback) {
        
        self.callback = callback;
        self.client = RestClient(callback: self.callback);
    }
    
    public func createPayment(receipt: [Item], amount: Double, desc: String) {
        let payment = CreatePayment(
            order: Order(
                currency: "RUB",
                amount: amount,
                desctription: desc,
                id: nil
            ),
            settings: Settings(
                terminal_id: self.terminalId
            ),
            receipt: receipt
        )
        client.request(createPayment: payment)
    }
}
