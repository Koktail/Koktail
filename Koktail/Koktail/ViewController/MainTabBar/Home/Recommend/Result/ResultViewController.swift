//
//  ResultViewController.swift
//  xib_result
//
//  Created by 형주 on 2021/07/16.
//

import UIKit

class ResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var imageArray = [UIImage(named: "cocktail"), UIImage(named: "cocktail"),
                      UIImage(named: "cocktail"), UIImage(named: "cocktail"),
                      UIImage(named: "cocktail"), UIImage(named: "cocktail"),
                      UIImage(named: "cocktail")]

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var againButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "CocktailResultTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.register(UINib(nibName: "HeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell1")
        againButton.layer.cornerRadius = againButton.frame.height / 2
        self.navigationController?.isNavigationBarHidden = true

    
    }
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell: HeaderTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "Cell1") as! HeaderTableViewCell
            cell.layer.frame.size.height = 300
            cell.headerBar.roundCorners(corners: [.topLeft, .topRight], radius: 20)
            cell.headerBar.addShadow(offset: CGSize(width: 0, height: -4))
            return cell
        }
        else{
            let cell: CocktailResultTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "Cell") as! CocktailResultTableViewCell
            cell.CocktailImage?.image = UIImage(named: "cocktail")
            cell.CocktailName?.text = "모히또"
            cell.CocktailInfo?.text = "단맛, 과일, 높은 도수"
            cell.CocktailAlc?.text = "Alc 16.2"
            cell.CocktailImage.applyshadowWithCorner(containerView: cell.Imageview, cornerRadious: 30)
            
            return cell
        }
        
    }

    @IBAction func againButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.navigationController?.popViewController(animated: false)
        let vc = SelectPageViewController(transitionStyle: UIPageViewController.TransitionStyle.scroll,
                                          navigationOrientation: UIPageViewController.NavigationOrientation.horizontal,
                                          options: nil)
        self.navigationController?.pushViewController(vc, animated: false)
//        pv!.setViewControllers([SelectBaseViewController()], direction: .forward, animated: true, completion: nil)
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
extension UIView {
    func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 3.0) {
            self.layer.masksToBounds = false
            self.layer.shadowColor = color.cgColor
            self.layer.shadowOffset = offset
            self.layer.shadowOpacity = opacity
            self.layer.shadowRadius = radius
        }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = 1
        if #available(iOS 11, *) {
            self.clipsToBounds = true
            self.layer.cornerRadius = radius
            var masked = CACornerMask()
            if corners.contains(.topLeft) { masked.insert(.layerMinXMinYCorner) }
            if corners.contains(.topRight) { masked.insert(.layerMaxXMinYCorner) }
            if corners.contains(.bottomLeft) { masked.insert(.layerMinXMaxYCorner) }
            if corners.contains(.bottomRight) { masked.insert(.layerMaxXMaxYCorner) }
           
            self.layer.maskedCorners = masked
        }
        else {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
}
extension UIImageView {
    func applyshadowWithCorner(containerView : UIView, cornerRadious : CGFloat){
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.gray.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        containerView.layer.shadowRadius = 2
        containerView.layer.cornerRadius = cornerRadious
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: cornerRadious).cgPath
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadious
    }
}
