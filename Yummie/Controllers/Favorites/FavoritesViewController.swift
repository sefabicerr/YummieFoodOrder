//
//  FavoritesViewController.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 17.05.2022.
//

import UIKit
import NVActivityIndicatorView

class FavoritesViewController: UIViewController,ActivityIndicatorProtocol {


    //MARK: - IBOutlets
    @IBOutlet weak var favoriteCollectionView: UICollectionView!
    
    //MARK: - Vars
    var favFoodList = [Favorites]()
    var imageLinkList = [String]()
    var activityIndicator: NVActivityIndicatorView?
    let d = UserDefaults.standard
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        registerCell()
        activityIndicator = createActivityIndicator()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favoriteCollectionView.backgroundView = EmptyView.emptyViewObj
        getFavoriteFoods()
        self.tabBarController?.tabBar.isHidden = true

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFavDetail" {
            let food = sender as? Favorites
            let VC = segue.destination as! FavoritesDetailViewController
            VC.food = food!
        }
    }
    
    //MARK: - Register cell func
    private func registerCell() {
        favoriteCollectionView.register(UINib(nibName: FavoriteCellCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: FavoriteCellCollectionViewCell.identifier)
    }
    
    //MARK: - Get favorite food from firebase
    private func getFavoriteFoods() {
        showLoadingIndicator(activityIndicator: activityIndicator)
        downloadItemsFromFirebase(with: User.currentId()) { (allFavoriteFoods) in
            self.favFoodList = allFavoriteFoods
            self.favoriteCollectionView.reloadData()
            self.hideLoadingIndicator(activityIndicator: self.activityIndicator)
        }
    }
    
    //MARK: - Delete favorite from firebase
    private func deleteFavorite(_ favorite: Favorites){
        let favoriteId = d.string(forKey: favorite.foodId)
        deleteToFirebase(with: favoriteId!)
        d.removeObject(forKey: favorite.foodId)
    }
}


extension FavoritesViewController: UICollectionViewDelegate,UICollectionViewDataSource,CellButtonProtocol {
    func deleteFav(indexPath: IndexPath) {
        deleteFavorite(favFoodList[indexPath.row])
        favFoodList.remove(at: indexPath.row)
        favoriteCollectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if favFoodList.count > 0 {
            collectionView.backgroundView?.isHidden = true
        } else {
            collectionView.backgroundView?.isHidden = false
            EmptyView.viewSetup("Favoriler Boş", "empty-favorite")
        }
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favFoodList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCellCollectionViewCell.identifier, for: indexPath) as! FavoriteCellCollectionViewCell
        let food = favFoodList[indexPath.row]
        cell.setup(food)
        cell.cellButtonProtocol = self
        cell.indexPath = indexPath
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let food = favFoodList[indexPath.row]
        performSegue(withIdentifier: "toFavDetail", sender: food)
    }
}
