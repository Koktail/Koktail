//
//  SelectAlcholViewController.swift
//  Koktail
//
//  Created by 형주 on 2021/07/17.
//

import UIKit

class SelectAlcholViewController: UIViewController {
    
    @IBOutlet weak var NonAlcholBaseButton: SelectButton!
    @IBOutlet weak var MiddleAlcholButton: SelectButton!
    @IBOutlet weak var HighAlcholButton: SelectButton!
//    @IBOutlet weak var previousButton: PreviousButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func LowBtnPress(_ sender: Any) {
        alcohol = "LOW"
        if let parentVC = self.parent as? SelectPageViewController {
            parentVC.goToNextPage()
        }
        setButtonWhite()
        self.NonAlcholBaseButton.backgroundColor = UIColor.lightGray
    }
    
    @IBAction func MiddleBtnPress(_ sender: Any) {
        alcohol = "MID"
        if let parentVC = self.parent as? SelectPageViewController {
            parentVC.goToNextPage()
        }
        setButtonWhite()
        self.MiddleAlcholButton.backgroundColor = UIColor.lightGray
    }
    
    @IBAction func HighBtnPress(_ sender: Any) {
        alcohol = "HIGH"
        if let parentVC = self.parent as? SelectPageViewController {
            parentVC.goToNextPage()
        }
        setButtonWhite()
        self.HighAlcholButton.backgroundColor = UIColor.lightGray
    }
    @IBAction func prevButton(_ sender: Any) {
        if let parentVC = self.parent as? SelectPageViewController {
            parentVC.goToPreviousPage()
        }
    }
    
    func setButtonWhite() {
        self.NonAlcholBaseButton.backgroundColor = UIColor.white
        self.MiddleAlcholButton.backgroundColor = UIColor.white
        self.HighAlcholButton.backgroundColor = UIColor.white
    }

}
