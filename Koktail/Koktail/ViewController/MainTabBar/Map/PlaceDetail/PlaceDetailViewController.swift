//
//  PlaceDetailViewController.swift
//  Koktail
//
//  Created by 최승명 on 2021/07/27.
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
    
    // MARK: - Action
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
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
        placeDetailTable.separatorColor = UIColor.clear
        placeDetailTable.separatorStyle = .none
        
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section != 0 {
            let sectionView = UIView().then {
                $0.backgroundColor = .systemGray4
                $0.tag = section
            }
            return sectionView
        } else {
            return UIView()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return self.placeDetail?.result.reviews.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let placeDetail = self.placeDetail else { return UITableViewCell() }
        
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: PlaceTitleTableViewCell.identifier,
                for: indexPath
            ) as? PlaceTitleTableViewCell else {
                return UITableViewCell()
            }
            cell.makeCell(place: placeDetail.result)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: PlaceInfoTableViewCell.identifier,
                    for: indexPath
            ) as? PlaceInfoTableViewCell else {
                return UITableViewCell()
            }
            cell.makeCell(place: placeDetail.result)
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: PlaceReviewsTableViewCell.identifier,
                    for: indexPath
            ) as? PlaceReviewsTableViewCell else {
                return UITableViewCell()
            }
            cell.makeCell(author: placeDetail.result.reviews[indexPath.row])
            return cell
        default:
            return UITableViewCell()
        }
    }
}
