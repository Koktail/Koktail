//
//  PlaceDetailViewController.swift
//  Koktail
//
//  Created by 최승명 on 2021/07/24.
//

import UIKit

class PlaceDetailViewController: UIViewController {

    @IBOutlet weak var placeDetailTable: UITableView!
    
    // MARK: - Override Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
    }
    
    // MARK: - Set Table View
    func setTableView() {
        placeDetailTable.delegate = self
        placeDetailTable.dataSource = self
        
        placeDetailTable.register(
            UINib(nibName: PlaceTitleTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: PlaceTitleTableViewCell.identifier
        )
        
        placeDetailTable.register(
            UINib(nibName: PlaceInfoTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: PlaceInfoTableViewCell.identifier
        )
        
        placeDetailTable.register(
            UINib(nibName: PlaceReviewsTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: PlaceReviewsTableViewCell.identifier
        )
    }
}

extension PlaceDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: PlaceTitleTableViewCell.identifier,
                for: indexPath
            ) as? PlaceTitleTableViewCell else {
                return UITableViewCell()
            }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: PlaceInfoTableViewCell.identifier,
                    for: indexPath
            ) as? PlaceInfoTableViewCell else {
                return UITableViewCell()
            }
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: PlaceReviewsTableViewCell.identifier,
                    for: indexPath
            ) as? PlaceReviewsTableViewCell else {
                return UITableViewCell()
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
}
