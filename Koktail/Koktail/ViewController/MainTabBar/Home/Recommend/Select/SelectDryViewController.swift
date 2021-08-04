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
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func MiddleBtnPress(_ sender: Any) {
        let vc = ResultViewController()
        dry = "MID"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func HighBtnPress(_ sender: Any) {
        let vc = ResultViewController()
        dry = "HIGH"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func prevButton(_ sender: Any) {
        if let parentVC = self.parent as? SelectPageViewController {
            parentVC.goToPreviousPage()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
