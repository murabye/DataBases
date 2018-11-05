    //
//  CreateDbView.swift
//  DataBases
//
//  Created by Владимир on 05/11/2018.
//  Copyright © 2018 варя. All rights reserved.
//

import UIKit

class CreateDbView: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpKeyBoardObservers()
        nameField.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter().removeObserver(self)
    }
    
    //MARK: - keyboard
    func setUpKeyBoardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboardWillShow(notification: NSNotification) {
        
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        if let keyboardFrame = keyboardFrame {
            self.heightConstraint.constant = -keyboardFrame.height
        }
        let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        if let keyboardDuration = keyboardDuration {
            UIView.animate(withDuration: keyboardDuration, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification) {
        
        self.heightConstraint.constant = 90
        let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        if let keyboardDuration = keyboardDuration {
            UIView.animate(withDuration: keyboardDuration, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let _ = 1 + 1
        return true
    }
    

}
