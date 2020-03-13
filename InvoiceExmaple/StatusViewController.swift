//
//  StatusViewController.swift
//  InvoiceExmaple
//
//  Created by Кирилл Кузнецов on 13/03/2020.
//  Copyright © 2020 InvoiceLLC. All rights reserved.
//

import Foundation
import UIKit

class StatusViewController: UIViewController {
    
    @IBOutlet weak var paymentStatus: UILabel!
    @IBOutlet weak var paymentAmount: UILabel!
    @IBOutlet weak var paymentBonusAmount: UILabel!
    @IBOutlet weak var paymentBonusGift: UILabel!
    
    var transaction: InvoiceTransaction = InvoiceTransaction();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paymentStatus.text = transaction.statusMsg ??  "";
        paymentAmount.text = transaction.amount ?? "0.0";
        paymentBonusAmount.text = transaction.amountbonus ?? "0";
        paymentBonusGift.text = transaction.bonus_gift ?? "0";
    }
}
