#  Invoice Payment Frame для IOS

<h3>PaymentFrame</h3>

Содержится в папке: **InvoicePaymentFrame**
В папке InvoiceExampe/backend содержится имитация бекенда

**Установка** 

Переместите файл **InvoicePaymentFrame.swift** в папку вашего проекта

**Использование(Xcode)**

1. Создайте WKWebView
2. В параметре **Identity Inspector -> Custom Class -> Class** установите значение PaymentFrame<br> 
![imgur](https://imgur.com/7xyAbDp.png)
3. Затем нужно получить id платежа из API вашего магазина<br>
   **Ни в коем случае не создавайте платеж на клиенте, как это сделано в примере(InvoiceExampe/backend), это не безопасно**<br>
   И загрузить PaymentFrame
   ```swift
   class PaymentViewController: UIViewController {
    
      public var paymentId: String = "paymentID"; //ID платежа
    
      @IBOutlet weak var frame: PaymentFrame!
    
      override func viewDidLoad() {
          super.viewDidLoad()
          class PaymentCallbackImpl: PaymentCallback {
              var context: PaymentViewController?;

              func onSuccess(status: InvoiceTransaction) {
                  //Действие при успешной оплате
              }

              func onError(status: InvoiceTransaction) {
                  //Действие при неудачной оплате
              }

              func onOtherStatus(status: InvoiceTransaction) {
                  //Действие при других статусах оплаты
              }
          }
          let callback = PaymentCallbackImpl()
          callback.context = self;

          frame
              .setPaymentCallback(callback: callback)
              .goPay(paymentId: self.paymentId)
      }
    
    }
   ```
