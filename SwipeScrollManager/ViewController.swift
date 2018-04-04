//
//  ViewController.swift
//  SwipeScrollManager
//
//  Created by Allan Gonzales on 4/4/18.
//  Copyright © 2018 Allan Gonzales. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    var list: [String: [String]] = [:]
    
    var extraCollectionView: UICollectionView!
    var collectionView: UICollectionView!
    var swipeScrollManager: SwipeScrollManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 120)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.white
        
        extraCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        extraCollectionView.dataSource = self
        extraCollectionView.delegate = self
        extraCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        extraCollectionView.backgroundColor = UIColor.white
        
        self.swipeScrollManager = SwipeScrollManager(centerView: collectionView, extraView: self.extraCollectionView, scrollView: self.scrollView)
        self.scrollView.delegate = self
        self.swipeScrollManager.delegate = self
        self.swipeScrollManager.reCenter()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
        self.swipeScrollManager.moveCardTo(index: CGFloat(index))
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
         let index = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
        self.swipeScrollManager.willMoveCardTo(index: index)
    }
}


extension ViewController: SwipeScrollManagerDelegate {
    
    func swipeWillMoveCard(direction: SwipeDirection) {
        switch direction {
        case .left: print("will move to left")
        case .right: print("will move to right")
        case .none: print("none")
        }
    }
    
    func swipeManagerDidMoveCard(direction: SwipeDirection) {
        switch direction {
        case .left: print("Did move to left")
        case .right: print("Did move to right")
        case .none: print("none")
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = UIColor.orange
        return cell
    }
}
