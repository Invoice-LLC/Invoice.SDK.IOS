//
//  invoiceStructs.swift
//  InvoiceExmaple
//
//  Created by Кирилл Кузнецов on 12/03/2020.
//  Copyright © 2020 Invoice LLC. All rights reserved.
//

import Foundation

struct CreateTerminal: Codable {
    var id: String?
    var name: String?
    var description: String?
    var type: String?
    var link: String?
    var error: String?
}

struct Order: Codable {
    var currency: String?
    var amount: Double?
    var desctription: String?
    var id: String?
}

struct Settings: Codable {
    var terminal_id: String?
}

struct Item: Codable {
    var name: String?
    var price: Double?
    var discount: String?
    var resultPrice: Double?
    var quantity: Int?
}

struct CreatePayment: Codable {
    var id: String?
    var order: Order?
    var settings: Settings?
    var receipt: [Item]?
}
