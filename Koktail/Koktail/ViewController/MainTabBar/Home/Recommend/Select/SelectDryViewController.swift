//
//  SelectDryViewController.swift
//  Koktail
//
//  Created by 형주 on 2021/07/18.
//

import UIKit

class SelectDryViewController: UIViewController {
    @IBOutlet weak var DryLowButton: SelectButton!
    @IBOutlet weak var DryMiddleButton: SelectButton!
    @IBOutlet weak var DryHighButton: SelectButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func LowBtnPress(_ sender: Any) {
        let vc = ResultViewController()
        dry = "LOW"
        setButtonWhite()
        self.DryLowButton.backgroundColor = UIColor.lightGray
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func MiddleBtnPress(_ sender: Any) {
        let vc = ResultViewController()
        dry = "MID"
        setButtonWhite()
        self.DryMiddleButton.backgroundColor = UIColor.lightGray
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func HighBtnPress(_ sender: Any) {
        let vc = ResultViewController()
        dry = "HIGH"
        setButtonWhite()
        self.DryHighButton.backgroundColor = UIColor.lightGray
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func prevButton(_ sender: Any) {
        if let parentVC = self.parent as? SelectPageViewController {
            parentVC.goToPreviousPage()
        }
    }
    
    func setButtonWhite() {
        self.DryHighButton.backgroundColor = UIColor.white
        self.DryMiddleButton.backgroundColor = UIColor.white
        self.DryLowButton.backgroundColor = UIColor.white
    }

}
