//
//  RequestCallback.swift
//  InvoiceExmaple
//
//  Created by Кирилл Кузнецов on 12/03/2020.
//  Copyright © 2020 Invoice LLC. All rights reserved.
//

import Foundation

protocol RequestCallback {
    func onSuccess(data: Data);
    func onError(error: Error);
}
