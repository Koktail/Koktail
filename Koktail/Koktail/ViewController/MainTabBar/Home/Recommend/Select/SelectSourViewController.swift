//
//  SelectSourViewController.swift
//  Koktail
//
//  Created by 형주 on 2021/07/18.
//

import UIKit

class SelectSourViewController: UIViewController {
    @IBOutlet weak var SourLowButton: SelectButton!
    @IBOutlet weak var SourMiddleButton: SelectButton!
    @IBOutlet weak var SourHighButton: SelectButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func LowBtnPress(_ sender: Any) {
        sour = "LOW"
        if let parentVC = self.parent as? SelectPageViewController {
            parentVC.goToNextPage()
        }
    }
    
    @IBAction func MiddleBtnPress(_ sender: Any) {
        sour = "MID"
        if let parentVC = self.parent as? SelectPageViewController {
            parentVC.goToNextPage()
        }
    }
    
    @IBAction func HighBtnPress(_ sender: Any) {
        sour = "HIGH"
        if let parentVC = self.parent as? SelectPageViewController {
            parentVC.goToNextPage()
        }
    }
    @IBAction func prevButton(_ sender: Any) {
        if let parentVC = self.parent as? SelectPageViewController {
            parentVC.goToPreviousPage()
        }
    }
}
