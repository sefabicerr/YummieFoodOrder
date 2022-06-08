//
//  OnBoardingViewController.swift
//  Yummie
//
//  Created by Muhammed Sefa Biçer on 19.04.2022.
//

import UIKit

class OnBoardingViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextBtn: UIButton!
    
    //VARS
    var slides: [OnBoardingSlide] = []
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1 {
                nextBtn.setTitle("Başla", for: .normal)
            } else {
                nextBtn.setTitle("İlerle", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        slides = [OnBoardingSlide(title: "Lezzetli Yemekler", description: "Dünya çapında farklı kültürlerden çeşitli harika yemekleri deneyimleyin.", image: UIImage(named: "slide2")!),
                  OnBoardingSlide(title: "Birinci Sınıf Şefler", description: "Yemekleriniz sadece en iyiler tarafından hazırlanır.", image: UIImage(named: "slide1")!),
                  OnBoardingSlide(title: "Anında Teslimat", description: "Dilediğiniz yemeği sipariş edin, 30 dakika içinde kapınıza gelsin.", image: UIImage(named: "slide3")!)]
        
        pageControl.numberOfPages = slides.count
    }
    

    @IBAction func nextBtnClicked(_ sender: Any) {
        if currentPage == slides.count - 1{
            let controller = storyboard?.instantiateViewController(withIdentifier: "LogInVC") as! LogInViewController
            controller.modalPresentationStyle = .fullScreen
            controller.modalTransitionStyle = .flipHorizontal
            present(controller, animated: true, completion: nil)
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}


extension OnBoardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnBoardingCollectionViewCell.identifier, for: indexPath) as! OnBoardingCollectionViewCell
        cell.setup(slides[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
}
