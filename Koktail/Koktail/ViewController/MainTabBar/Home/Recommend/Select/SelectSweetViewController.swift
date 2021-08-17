//
//  SelectSweetViewController.swift
//  Koktail
//
//  Created by 형주 on 2021/07/18.
//

import UIKit

class SelectSweetViewController: UIViewController {
    @IBOutlet weak var SweetLowButton: SelectButton!
    @IBOutlet weak var SweetMiddleButton: SelectButton!
    @IBOutlet weak var SweetHighButton: SelectButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func LowBtnPress(_ sender: Any) {
        sweet = "LOW"
        if let parentVC = self.parent as? SelectPageViewController {
            parentVC.goToNextPage()
        }
        setButtonWhite()
        self.SweetLowButton.backgroundColor = UIColor.lightGray
    }
    
    @IBAction func MiddleBtnPress(_ sender: Any) {
        sweet = "MID"
        if let parentVC = self.parent as? SelectPageViewController {
            parentVC.goToNextPage()
        }
        setButtonWhite()
        self.SweetMiddleButton.backgroundColor = UIColor.lightGray
    }
    
    @IBAction func HighBtnPress(_ sender: Any) {
        sweet = "HIGH"
        if let parentVC = self.parent as? SelectPageViewController {
            parentVC.goToNextPage()
        }
        setButtonWhite()
        self.SweetHighButton.backgroundColor = UIColor.lightGray
    }
    @IBAction func prevButton(_ sender: Any) {
        if let parentVC = self.parent as? SelectPageViewController {
            parentVC.goToPreviousPage()
        }
    }
    
    func setButtonWhite() {
        self.SweetHighButton.backgroundColor = UIColor.white
        self.SweetLowButton.backgroundColor = UIColor.white
        self.SweetMiddleButton.backgroundColor = UIColor.white
    }
}
