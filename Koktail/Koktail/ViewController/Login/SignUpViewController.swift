//
//  SignUpViewController.swift
//  Koktail
//
//  Created by 정연희 on 2021/07/12.
//

import UIKit
import TextFieldEffects
import Firebase

class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var emailTextField: HoshiTextField!
    @IBOutlet weak var passwordTextField: HoshiTextField!
    @IBOutlet weak var checkPasswordTextField: HoshiTextField!
    
    var color: String!
    
    // Firebase
    let remoteConfig = RemoteConfig.remoteConfig()
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Custom Methods
    func initProperties() {
        self.color = remoteConfig["splash_background"].stringValue
        
        self.signUpButton.backgroundColor = UIColor(hex: self.color)
        self.cancelButton.backgroundColor = UIColor(hex: self.color)
    }
    
}
