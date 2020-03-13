//
//  ViewController.swift
//  InvoiceExmaple
//
//  Created by Кирилл Кузнецов on 12/03/2020.
//  Copyright © 2020 Invoice LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func payButton(_ sender: Any) {
        class CallbackImp : RequestCallback {
            var context: ViewController?;
            
            func onSuccess(data: Data) {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Payment", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
                
                let payment = try! JSONDecoder().decode(CreatePayment.self, from: data)
                newViewController.paymentId = payment.id ?? "";
                
                context?.present(newViewController, animated: true, completion: nil)
                
            }
            
            func onError(error: Error) {
                
            }
        }
        
        let callback = CallbackImp();
        callback.context = self;
        
        let receipt:[Item] = [
                Item(
                    name: "Суп",
                    price: 40.0,
                    discount: "0",
                    resultPrice: 40.0,
                    quantity: 1
                ),
                Item(
                    name: "Кефир",
                    price: 10.0,
                    discount: "0",
                    resultPrice: 20.0,
                    quantity: 2
                )
            ]
        let processing = InvoiceProcessing(callback: callback)
        processing.createPayment(receipt: receipt, amount: 60.0, desc: "Обед");
    }
    
}

