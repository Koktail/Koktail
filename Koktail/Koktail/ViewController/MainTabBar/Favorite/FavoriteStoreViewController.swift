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
        
        storeTableView.register(
            UINib(nibName: FavoriteStoreTableViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: FavoriteStoreTableViewCell.identifier
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
        return storeList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let storeList = self.storeList else { return UITableViewCell() }
        
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: FavoriteStoreTableViewCell.identifier,
                for: indexPath
        ) as? FavoriteStoreTableViewCell else {
            return UITableViewCell()
        }
        cell.makeCell(store: storeList[indexPath.row])
        return cell
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
}
