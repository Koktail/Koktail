//
//  PlaceDetailViewController.swift
//  Koktail
//
//  Created by 최승명 on 2021/07/27.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class PlaceDetailViewController: UIViewController {

    // MARK: - Properties
    // view
    private lazy var placeDetailTable = UITableView()
    
    private lazy var containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
    }
    
    private let maxDimmedAlpha: CGFloat = 0.6
    private lazy var dimmedView = UIView().then {
        $0.backgroundColor = .black
        $0.alpha = maxDimmedAlpha
    }
    
    // Constants
    private let defaultHeight: CGFloat = 300
    private let dismissibleHeight: CGFloat = 200
    private let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height - 64
    private var currentContainerHeight: CGFloat = 300
    
    // Dynamic container constraint
    private var containerViewHeightConstraint: NSLayoutConstraint?
    private var containerViewBottomConstraint: NSLayoutConstraint?
    
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
        
        setupView()
        setupConstraints()
        setupPanGesture()
        setTableView()
        
        bindNetworkingState()
        requestPlaceDetail(place_id: self.placeName!)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateShowDimmedView()
        animatePresentContainer()
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
    
    // MARK: - Networking
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
            cell.placeDetail = placeDetail
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

// MARK: - Modal
extension PlaceDetailViewController {
    
    // MARK: - objc Action
    @objc func handleCloseAction() {
        animateDismissView()
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let isDraggingDown = translation.y > 0
        let newHeight = currentContainerHeight - translation.y
        
        switch gesture.state {
        case .changed:
            if newHeight < maximumContainerHeight {
                containerViewHeightConstraint?.constant = newHeight
                view.layoutIfNeeded()
            }
        case .ended:
            if newHeight < dismissibleHeight {
                self.animateDismissView()
            } else if newHeight < defaultHeight {
                animateContainerHeight(defaultHeight)
            } else if newHeight < maximumContainerHeight && isDraggingDown {
                animateContainerHeight(defaultHeight)
            } else if newHeight > defaultHeight && !isDraggingDown {
                animateContainerHeight(maximumContainerHeight)
            }
        default:
            break
        }
    }
    
    private func setupView() {
        view.backgroundColor = .clear
    }
    
    private func setupConstraints() {
        view.addSubview(dimmedView)
        view.addSubview(containerView)
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(placeDetailTable)
        placeDetailTable.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // set dimmedView edges to superview
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // set container static constraint (trailing & leading)
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // content stackView
            placeDetailTable.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 32),
            placeDetailTable.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            placeDetailTable.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            placeDetailTable.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ])

        containerViewHeightConstraint = containerView.heightAnchor.constraint(
            equalToConstant: defaultHeight
        )
        containerViewBottomConstraint = containerView.bottomAnchor.constraint(
            equalTo: view.bottomAnchor,
            constant: defaultHeight
        )
        
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
    }
    
    private func setupPanGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleCloseAction))
        dimmedView.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        view.addGestureRecognizer(panGesture)
    }
    
    // MARK: Present and dismiss animation
    private func animatePresentContainer() {
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    private func animateShowDimmedView() {
        dimmedView.alpha = 0
        self.dimmedView.alpha = self.maxDimmedAlpha
    }
    
    private func animateDismissView() {
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.3) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            self.view.layoutIfNeeded()
        }
    }
    
    private func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.3) {
            self.containerViewHeightConstraint?.constant = height
            self.view.layoutIfNeeded()
        }
        currentContainerHeight = height
    }
}
