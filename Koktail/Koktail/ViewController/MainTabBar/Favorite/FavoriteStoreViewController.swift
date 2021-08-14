//
//  FavoriteStoreViewController.swift
//  Koktail
//
//  Created by 최승명 on 2021/07/03.
//

import UIKit
import RealmSwift

class FavoriteStoreViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var storeTableView: UITableView!
    
    // realm
    private var realm: Realm?
    private var storeList: Results<StoreData>?
    
    // manage view
    private let indicator: UIRefreshControl = UIRefreshControl()
    
    // MARK: - Action
    @objc func pullToRefresh() {
        loadRealm()
    }
    
    // MARK: - Overrride Method
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        loadRealm()
    }
    
    // MARK: - Set Table View
    private func setTableView() {
        
        indicator.addTarget(
            self,
            action: #selector(pullToRefresh),
            for: .valueChanged
        )
        
        storeTableView.refreshControl = indicator
        storeTableView.delegate = self
        storeTableView.dataSource = self
        storeTableView.tableFooterView = UIView()
        storeTableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        storeTableView.register(
            UINib(nibName: FavoriteStoreTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: FavoriteStoreTableViewCell.identifier
        )
        
        storeTableView.register(
            UINib(nibName: FavoriteStoreEmptyTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: FavoriteStoreEmptyTableViewCell.identifier
        )
    }
    
    // MARK: - Set Realm
    private func loadRealm() {
        realm = try? Realm()
        print("realm file: \(Realm.Configuration.defaultConfiguration.fileURL!)")
        
        guard let store = realm?.objects(StoreData.self) else { return }
        self.storeList = store
        
        indicator.endRefreshing()
        storeTableView.reloadData()
    }
}

extension FavoriteStoreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let storeList = self.storeList else { return 0 }
        
        if storeList.isEmpty {
            return 1
        } else {
            return storeList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let storeList = self.storeList else { return UITableViewCell() }
        
        if storeList.isEmpty {
            tableView.isScrollEnabled = false
            tableView.separatorStyle = .none
            
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: FavoriteStoreEmptyTableViewCell.identifier,
                    for: indexPath
            ) as? FavoriteStoreEmptyTableViewCell else {
                return UITableViewCell()
            }
            return cell
        } else {
            tableView.isScrollEnabled = true
            tableView.separatorStyle = .singleLine
            
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: FavoriteStoreTableViewCell.identifier,
                    for: indexPath
            ) as? FavoriteStoreTableViewCell else {
                return UITableViewCell()
            }
            cell.makeCell(store: storeList[indexPath.row])
            return cell
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            guard let storeList = self.storeList else { return }
            try? realm?.write {
                realm?.delete(storeList[indexPath.row])
            }
            
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let storeList = self.storeList else { return 0 }
        
        if storeList.isEmpty {
            return 422
        } else {
            return 250
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let storeList = self.storeList else { return 0 }
        
        if storeList.isEmpty {
            return 0.1
        } else {
            return 1
        }
    }
}
