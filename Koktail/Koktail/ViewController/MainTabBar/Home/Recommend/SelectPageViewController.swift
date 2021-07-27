//
//  SelectPageViewController.swift
//  Koktail
//
//  Created by 형주 on 2021/07/17.
//

import UIKit
var pv : SelectPageViewController? = nil
class SelectPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate{

    lazy var VCArray:[UIViewController] = {
        return [SelectBaseViewController(nibName: "SelectBaseViewController",
                                         bundle: nil),
                SelectAlcholViewController(nibName: "SelectAlcholViewController", bundle: nil),
                SelectSweetViewController(nibName: "SelectSweetViewController", bundle: nil),
                SelectSourViewController(nibName: "SelectSourViewController", bundle: nil),
                SelectBitterViewController(nibName: "SelectBitterViewController", bundle: nil),
                SelectDryViewController(nibName: "SelectDryViewController", bundle: nil)]
    }()
    
    private func VCInstance(name: String)-> UIViewController{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func MyAfter(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?{
        guard let viewControllerIndex = VCArray.index(of: viewController) else {
            return nil
        }

        let nextIndex = viewControllerIndex + 1

        guard nextIndex < VCArray.count else {

            return VCArray.first
        }

        guard VCArray.count > nextIndex else {
            return nil
        }

        return VCArray[nextIndex]
    }
    
    override var transitionStyle: UIPageViewController.TransitionStyle {
        return .scroll
    }
    
    func MyBefor(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = VCArray.index(of: viewController) else {
            return nil
        }

        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else {
            return VCArray.last
        }

        guard VCArray.count > previousIndex else {
            return nil
        }

        return VCArray[previousIndex]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for view in self.view.subviews {
                if let subView = view as? UIScrollView {
                    subView.isScrollEnabled = false
                }
            }
        
        for recognizer in self.gestureRecognizers {
            recognizer.isEnabled = false
        }

        pv = self
        self.dataSource = self
        self.navigationController?.isNavigationBarHidden = true
        if let firstVC = VCArray.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SelectPageViewController {
    
    func goToNextPage() {
       guard let currentViewController = self.viewControllers?.first else { return }
        guard let nextViewController = self.MyAfter(self, viewControllerAfter: currentViewController) else {return}
       setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
    }

    func goToPreviousPage() {
       guard let currentViewController = self.viewControllers?.first else { return }
        print(currentViewController)
        guard let previousViewController = self.MyBefor(self, viewControllerAfter: currentViewController) else {return}
       setViewControllers([previousViewController], direction: .reverse, animated: true, completion: nil)
    }
   
}
