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
        pv!.goToNextPage()
    }
    
    @IBAction func MiddleBtnPress(_ sender: Any) {
        pv!.goToNextPage()
    }
    
    @IBAction func HighBtnPress(_ sender: Any) {
        pv!.goToNextPage()
    }
    @IBAction func prevButton(_ sender: Any) {
        pv!.goToPreviousPage()
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
