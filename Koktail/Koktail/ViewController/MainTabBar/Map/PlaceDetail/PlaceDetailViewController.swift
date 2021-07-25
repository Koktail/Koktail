//
//  PlaceDetailViewController.swift
//  Koktail
//
//  Created by 최승명 on 2021/07/24.
//

import UIKit
import RxSwift
import RxCocoa

class PlaceDetailViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var placeDetailTable: UITableView!

    // data
    public var placeName: String?
    private var placeDetail: PlaceDetail?
    
    // view model
    private let placeDetailViewModel = PlaceDetailViewModel()
    
    // RxSwift
    private let disposeBag = DisposeBag()
    
    // MARK: - Override Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        
        bindNetworkingState()
        requestPlaceDetail(place_id: self.placeName!)
    }
    
    // MARK: - Set Table View
    private func setTableView() {
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
    
    private func requestPlaceDetail(place_id: String) {
        let parameters: [String: String] = [
            "key": "AIzaSyCcXxMzsdL1m2uPjZ6d9wGTiVDYm4srnHU",
            "place_id": place_id,
            "language": "ko"
        ]
        
        placeDetailViewModel.request(parameters: parameters)
    }
    
    private func bindNetworkingState() {
        placeDetailViewModel.state.success
            .asDriver(onErrorDriveWith: Driver.empty())
            .drive { placeDetail in
                self.placeDetail = placeDetail
                self.placeDetailTable.reloadData()
            }.disposed(by: disposeBag)
        
        placeDetailViewModel.state.fail
            .filter {$0 == true}
            .asDriver(onErrorDriveWith: Driver.empty())
            .drive { _ in
                print("placeDetailData load fail")
            }.disposed(by: disposeBag)
    }
    
}

// MARK: - Table View
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
