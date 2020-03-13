//
//  PaymentViewController.swift
//  InvoiceExmaple
//
//  Created by Кирилл Кузнецов on 12/03/2020.
//  Copyright © 2020 Invoice LLC. All rights reserved.
//

import Foundation
import UIKit
import WebKit

class PaymentViewController: UIViewController {
    
    public var paymentId: String = "unknown";
    
    @IBOutlet weak var frame: PaymentFrame!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pay();
        print("PaymentID: "+paymentId)
    }
    
    func pay() {
        class PaymentCallbackImpl: PaymentCallback {
            var context: PaymentViewController?;
        
            func onSuccess(status: InvoiceTransaction) {
                context?.goToStatus(status: status)
            }
            
            func onError(status: InvoiceTransaction) {
                context?.goToStatus(status: status)
            }
            
            func onOtherStatus(status: InvoiceTransaction) {
                context?.goToStatus(status: status)
            }
        }
        let callback = PaymentCallbackImpl()
        callback.context = self;
        
        frame
            .setPaymentCallback(callback: callback)
            .goPay(paymentId: self.paymentId)
    }
    
    func goToStatus(status: InvoiceTransaction) {

        let storyBoard: UIStoryboard = UIStoryboard(name: "Status", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "StatusViewController") as! StatusViewController
        
        newViewController.transaction = status;
        
        present(newViewController, animated: true, completion: nil)

    }
    
}

