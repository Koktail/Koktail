//
//  SelectBitterViewController.swift
//  Koktail
//
//  Created by 형주 on 2021/07/18.
//

import UIKit

class SelectBitterViewController: UIViewController {
    @IBOutlet weak var BitterLowButton: SelectButton!
    @IBOutlet weak var BitterMiddleButton: SelectButton!
    @IBOutlet weak var BitterHighButton: SelectButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func LowBtnPress(_ sender: Any) {
        bitter = "LOW"
        if let parentVC = self.parent as? SelectPageViewController {
            parentVC.goToNextPage()
        }
        setButtonWhite()
        self.BitterLowButton.backgroundColor = UIColor.lightGray
    }
    
    @IBAction func MiddleBtnPress(_ sender: Any) {
        bitter = "MID"
        if let parentVC = self.parent as? SelectPageViewController {
            parentVC.goToNextPage()
        }
        setButtonWhite()
        self.BitterMiddleButton.backgroundColor = UIColor.lightGray
    }
    
    @IBAction func HighBtnPress(_ sender: Any) {
        bitter = "HIGH"
        if let parentVC = self.parent as? SelectPageViewController {
            parentVC.goToNextPage()
        }
        setButtonWhite()
        self.BitterHighButton.backgroundColor = UIColor.lightGray
    }
    
    @IBAction func prevButton(_ sender: Any) {
        if let parentVC = self.parent as? SelectPageViewController {
            parentVC.goToPreviousPage()
        }
    }
    
    func setButtonWhite() {
        self.BitterHighButton.backgroundColor = UIColor.white
        self.BitterMiddleButton.backgroundColor = UIColor.white
        self.BitterLowButton.backgroundColor = UIColor.white
    }

}
