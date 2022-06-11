//
//  HomeViewController.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 11.05.2022.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var slideImageCollectionView: UICollectionView!
    @IBOutlet weak var boxCollectionView: UICollectionView!
    @IBOutlet weak var foodsCollectionView: UICollectionView!
    @IBOutlet weak var selectedAdressTableView: UITableView!
    @IBOutlet weak var pageController: UIPageControl!
    
    //MARK: - Vars
    var slides = [sliderImageAtHome]()
    var boxItems = [BoxCellAtHome]()
    var foodList = [Foods]()
    var currentPage = 0
    var adressText = ""
    var timer : Timer?
    var cellCurrentIndex = 0
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        createCellInfos()
        showAllFoods()
        startTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserAdress()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - For pagecontroller
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(goToNextIndex), userInfo: nil, repeats: true)
    }
    
    @objc func goToNextIndex() {
        if cellCurrentIndex < slides.count - 1 {
            cellCurrentIndex += 1
        }else {
            cellCurrentIndex = 0
        }
        slideImageCollectionView.scrollToItem(at: IndexPath(item: cellCurrentIndex, section: 0), at: .centeredHorizontally, animated: true)
        pageController.currentPage = cellCurrentIndex
    }
    
    //MARK: Connection of cell design
    private func registerCells() {
        boxCollectionView.register(UINib(nibName: BoxCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: BoxCollectionViewCell.identifier)
        foodsCollectionView.register(UINib(nibName: FoodCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: FoodCollectionViewCell.identifier)
        selectedAdressTableView.register(UINib(nibName: SelectedAdressTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SelectedAdressTableViewCell.identifier)
    }
    
    func createCellInfos() {
        slides = [sliderImageAtHome(image: UIImage(named: "slider1")!),sliderImageAtHome(image: UIImage(named: "slider2")!),sliderImageAtHome(image: UIImage(named: "slider3")!),sliderImageAtHome(image: UIImage(named: "slider4")!),sliderImageAtHome(image: UIImage(named: "slider5")!),sliderImageAtHome(image: UIImage(named: "slider6")!)]
        pageController.numberOfPages = slides.count
        boxItems = [BoxCellAtHome(title: "Favorilerim", image: UIImage(systemName: "suit.heart")!),BoxCellAtHome(title: "Adreslerim", image: UIImage(systemName: "map")!),BoxCellAtHome(title: "Siparişlerim", image: UIImage(systemName: "list.bullet.rectangle")!)]
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFoodDetail" {
            let food = sender as? Foods
            let VC = segue.destination as! FoodDetailViewController
            VC.food = food!
        }
    }
    
    //MARK: - Func of displaying the foods from the service in the collectionView
    private func showAllFoods() {
        Service.showAllFoods() { response in
            self.foodList = response
            DispatchQueue.main.async {
                self.foodsCollectionView.reloadData()
            }
        }
    }
    
    //MARK: - To get the user address
    private func getUserAdress() {
        downloadUserAdressFromFirebase(with: User.currentId()) { (adress) in
            self.adressText = adress
            self.selectedAdressTableView.reloadData()
        }
    }
}


extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectedAdressTableViewCell.identifier, for: indexPath) as! SelectedAdressTableViewCell
        cell.createBackView()
        cell.setup(adressText)
        return cell
    }
}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case slideImageCollectionView:
            return slides.count
        case boxCollectionView:
            return boxItems.count
        case foodsCollectionView:
            return foodList.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case slideImageCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sliderImageCollectionViewCell.identifier, for: indexPath) as! sliderImageCollectionViewCell
            cell.setup(slides[indexPath.row])
            return cell
        case boxCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BoxCollectionViewCell.identifier, for: indexPath) as! BoxCollectionViewCell
            cell.setup(boxItems[indexPath.row])
            return cell
        case foodsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FoodCollectionViewCell.identifier, for: indexPath) as! FoodCollectionViewCell
            cell.setup(foodList[indexPath.row])
            return cell
        default: return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch collectionView {
    
    case boxCollectionView:
        if indexPath.row == 0 {
            performSegue(withIdentifier: "toFavorites", sender: nil)
        } else if indexPath.row == 2 {
            performSegue(withIdentifier: "toOrdered", sender: nil)
        } else if indexPath.row == 1 {
            performSegue(withIdentifier: "toAdress", sender: nil)
        }
        
    case foodsCollectionView:
        let food = foodList[indexPath.row]
        performSegue(withIdentifier: "toFoodDetail", sender: food)
    default: print("hata")
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
}
