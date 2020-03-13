//
//  PaymentCallback.swift
//  InvoiceExmaple
//
//  Created by Кирилл on 12/03/2020.
//  Copyright © 2020 Кирилл. All rights reserved.
//

import Foundation

protocol PaymentCallback {
    func onSuccess(status: PaymentStatus)
    func onError(error: String, code: Int)
    func onOtherStatus(status: PaymentStatus)
}
