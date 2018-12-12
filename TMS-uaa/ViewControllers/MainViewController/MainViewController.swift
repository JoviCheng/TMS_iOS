//
//  DemoViewController.swift
//  TMS-uaa
//
//  Created by JoviCheng on 2018/12/11.
//  Copyright © 2018年 JoviCheng. All rights reserved.
//

import Foundation
import UIKit
import expanding_collection

class MainViewController: ExpandingViewController {
    
    typealias ItemInfo = (imageName: String, title: String)
    fileprivate var cellsIsOpen = [Bool]()
    fileprivate let items: [ItemInfo] = [("color0", "游戏策划与角色设计"), ("color1", "软件测试方法与技术"), ("color2", "交互体验与应用"), ("color3", "移动前端编程技术")]
    
//    @IBOutlet var pageLabel: UILabel!
}

// MARK: - Lifecycle 🌎

extension MainViewController {
    
    override func viewDidLoad() {
        itemSize = CGSize(width: 256, height: 460)
        super.viewDidLoad()
        
        registerCell()
        fillCellIsOpenArray()
        addGesture(to: collectionView!)
        configureNavBar()
    }
}

extension MainViewController {
    
    fileprivate func registerCell() {
        
        let nib = UINib(nibName: String(describing: CourseCollectionViewCell.self), bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: String(describing: CourseCollectionViewCell.self))
    }
    
    fileprivate func fillCellIsOpenArray() {
        //注册Cell 的打开状态，初始化全为 False
        cellsIsOpen = Array(repeating: false, count: items.count)
        print(cellsIsOpen)
    }
    
    fileprivate func closeOthersCell(activeIndex: Int) {
        //注册Cell 的打开状态，初始化全为 False
        cellsIsOpen[activeIndex] = false
        print(cellsIsOpen)
    }
    
    fileprivate func getViewController() -> ExpandingTableViewController {
        let storyboard = UIStoryboard(storyboard: .Main)
        let toViewController: CourseDetailViewController = storyboard.instantiateViewController()
        return toViewController
    }

    //设置导航栏（左边按钮
    fileprivate func configureNavBar() {
        navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    }
}

/// MARK: Gesture
extension MainViewController {
    //注册手势
    fileprivate func addGesture(to view: UIView) {
        let upGesture = Init(UISwipeGestureRecognizer(target: self, action: #selector(MainViewController.swipeHandler(_:)))) {
            $0.direction = .up
        }
        
        let downGesture = Init(UISwipeGestureRecognizer(target: self, action: #selector(MainViewController.swipeHandler(_:)))) {
            $0.direction = .down
        }
        view.addGestureRecognizer(upGesture)
        view.addGestureRecognizer(downGesture)
    }
    
    @objc func swipeHandler(_ sender: UISwipeGestureRecognizer) {
        let indexPath = IndexPath(row: currentIndex, section: 0)
        guard let cell = collectionView?.cellForItem(at: indexPath) as? CourseCollectionViewCell else { return }
        // double swipe Up transition
        
        //如果 Cell 被打开，且手势向上，则 Push 至下一个 View
        if cell.isOpened == true && sender.direction == .up {
            pushToViewController(getViewController())
            //修改右上角按钮
            if let rightButton = navigationItem.rightBarButtonItem as? AnimatingBarButton {
                rightButton.animationSelected(true)
            }
        }
        
        let open = sender.direction == .up ? true : false
        cell.cellIsOpen(open)
        // 如果为 false，则关闭 Cell
        print(cell.isOpened)
        cellsIsOpen[indexPath.row] = cell.isOpened
    }
}

// MARK: UICollectionViewDataSource

extension MainViewController {
    
    //重写collectionView
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        super.collectionView(collectionView, willDisplay: cell, forItemAt: indexPath)
        guard let cell = cell as? CourseCollectionViewCell else { return }
        //渲染下一个显示的Cell
        let index = indexPath.row % items.count
        //        print(items.count)
        //        print(indexPath)
        //        print(index)
        //        print(currentIndex)
        let info = items[index]
        print(info)
        cell.backgroundImageView?.image = UIImage(named: info.imageName)
        cell.courseTitle.text = info.title
        cell.cellIsOpen(cellsIsOpen[index], animated: false)
        print(cellsIsOpen)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CourseCollectionViewCell
            , currentIndex == indexPath.row else { return }
        print(currentIndex)
        
        if cell.isOpened == false {
            cell.cellIsOpen(true)
        } else {
            pushToViewController(getViewController())
            
            if let rightButton = navigationItem.rightBarButtonItem as? AnimatingBarButton {
                rightButton.animationSelected(true)
            }
        }
    }
}

// MARK: UICollectionViewDataSource

extension MainViewController {
    
    override func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CourseCollectionViewCell.self), for: indexPath)
    }
}

