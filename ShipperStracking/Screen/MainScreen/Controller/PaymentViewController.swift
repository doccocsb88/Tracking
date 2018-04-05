//
//  PaymentViewController.swift
//  ShipperStracking
//
//  Created by Apple on 3/28/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
protocol PaymentDelegate: class  {
    func didFinishedPayment()
    
}
class PaymentViewController: BaseViewController, UITextFieldDelegate {

    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var cardNumberTextField: UITextField!
    
    @IBOutlet weak var ccvNumberLabel: UILabel!
    @IBOutlet weak var ccvNumberTextField: UITextField!
    
    @IBOutlet weak var expiredDateLabel: UILabel!
    @IBOutlet weak var expiredDateTextField: UITextField!
    
    @IBOutlet weak var cardHolderLabel: UILabel!
    @IBOutlet weak var cardHolderTextfield: UITextField!
    
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    weak var delegate:PaymentDelegate?
    var bike:Bike!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func paybuttonTapped(_ sender: Any) {
        guard let cardNumber = self.cardNumberTextField.text, !cardNumber.isEmpty else{
            self.cardNumberTextField.becomeFirstResponder()
            return
        }
        guard let expiredDate = self.expiredDateTextField.text, !expiredDate.isEmpty else{
            self.expiredDateTextField.becomeFirstResponder()
            return
        }
        guard let cvCode = self.ccvNumberTextField.text, !cvCode.isEmpty else{
            self.ccvNumberTextField.becomeFirstResponder()
            return
        }
        guard let cardHolder = self.cardHolderTextfield.text, !cardHolder.isEmpty else{
            
            self.cardHolderTextfield.becomeFirstResponder()
            return
        }
        self.view.endEditing(true)
        let dateArr = expiredDate.components(separatedBy: "/")
        let formatedExpiredDate = dateArr.joined(separator: "_")
        
        let cardHolderArr = cardHolder.components(separatedBy: " ")
        let formatedCardHolder =  cardHolderArr.joined(separator: "_")
        showLoadingView(message: "Loading...")
        APISerives.payment(cardNumber: cardNumber, expiryDate: formatedExpiredDate, cardHolder: formatedCardHolder, ccv_number: cvCode) { (response) in
            if let response = response {
                print("\(response)")
                let status  = response["status"] as? Bool ?? false
                
                if status{
                    if let info = response["info"] as? NSDictionary{
                        RentInfo.shared.bikeId = info["bikeId"] as? String ?? ""
                        RentInfo.shared.code = info["code"] as? String ?? ""
                    }
                    self.toogleCreditCardError(error: false, message: "")
                    self.delegate?.didFinishedPayment()
                    self.navigationController?.popViewController(animated: true)
                }else{
                    if let errorMessage = response["error"] as? String{
//                        self.showAlertMessage(title: "Error", message: error, completion: {})
                        self.toogleCreditCardError(error: true, message: errorMessage)
                    }else{
                        self.showAlertMessage(title: "Error", message: ErrorMessage.unknow.rawValue, completion: {})
                    }
                }
            }else{
                self.showAlertMessage(title: "Error", message: ErrorMessage.unknow.rawValue,completion: {})
            }
            self.hideLoadingView()
        }
        print("start payment")
    }
}
extension PaymentViewController{
    func setupView(){
        self.setupNavigator()
        self.cardHolderTextfield.delegate = self;
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        containerView.addGestureRecognizer(tap)
        containerView.isUserInteractionEnabled = true
        containerView.addGestureRecognizer(tap)
    }
    func setupNavigator(){
        self.navigationItem.title = "you rent this bike \(self.bike.bikeId!)"
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        self.view.endEditing(true)
    }
    func toogleCreditCardError(error:Bool, message:String){
        self.messageLabel.text = message
        self.messageLabel.isHidden = !error
    }
}
extension PaymentViewController{

    func textFieldDidBeginEditing(_ textField: UITextField) {
        let scrollPoint = CGPoint(x: 0, y: textField.frame.origin.y - 200)
        self.scrollView .setContentOffset(scrollPoint, animated: true)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.scrollView .setContentOffset(CGPoint.zero, animated: true)

    }


    
}
extension UITextField{
    func addBorderWithColor(color: UIColor){
        self.layer.cornerRadius = 5.0;
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = true
    }
}
