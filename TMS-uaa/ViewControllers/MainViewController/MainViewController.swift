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
import SwiftyJSON

class MainViewController: ExpandingViewController {
    
    let imageArray:Array = ["red","yellow","royal","blue"]
    typealias ItemInfo = (imageName: String, course: String, startWeek:Int,teacher:String,endWeek:Int,dayOfWeek:Int,totalSection:Int,place:String,startSection:Int)
    fileprivate var cellsIsOpen = [Bool]()
    fileprivate var items: [ItemInfo] = []
//    @IBOutlet var pageLabel: UILabel!
    
    @IBOutlet var weekTabel: UILabel!
    @IBOutlet var nameTabel: UILabel!
    
}

// MARK: - Lifecycle 🌎

extension MainViewController {
    
    override func viewDidLoad() {
        itemSize = CGSize(width: 256, height: 460)
        super.viewDidLoad()
        
        loadCourse()
        registerCell()
        fillCellIsOpenArray()
        addGesture(to: collectionView!)
        configureNavBar()
        
        weekTabel.layer.shadowRadius = 2
        weekTabel.layer.shadowOffset = CGSize(width: 0, height: 3)
        weekTabel.layer.shadowOpacity = 0.2
        
        nameTabel.layer.shadowRadius = 2
        nameTabel.layer.shadowOffset = CGSize(width: 0, height: 3)
        nameTabel.layer.shadowOpacity = 0.2
    }
}

extension MainViewController {
    
    fileprivate func loadCourse() {
        let jsonPathx = NSHomeDirectory() + "/Documents/Schedule.json"
        let data = NSData.init(contentsOfFile: jsonPathx)
        let courseData = JSON(data!)
        let username = courseData["username"]
        nameTabel.text = "\("欢迎回来，")\(username.stringValue)"
        print(courseData["schedules"])
        let currentWeek:Int! = courseData["term"]["currentWeek"].intValue
        weekTabel.text = "当前教学周：第"+String(currentWeek)+"周"
        for course in courseData["schedules"].arrayValue {
            print(course)
            //此处是做课程周判断，判断是否当周的课程，为了演示方便，先把此处过滤代码注释掉。
//            if(course["startWeek"].intValue <= currentWeek && currentWeek <= course["endWeek"].intValue){
            items.append((imageName: imageArray[Int.random(in: 0 ..< 4)], course: course["course"].stringValue,startWeek:course["startWeek"].intValue,teacher:course["teacherName"].stringValue,endWeek:course["endWeek"].intValue,dayOfWeek:course["dayOfWeek"].intValue,totalSection:course["totalSection"].intValue,place:course["place"].stringValue,startSection:course["startSection"].intValue))
//            }
        }
        //每天给课程排序
        for i in 0..<items.count{
            var bool = true
            var m:Int = 0
            var n:Int = 0
            for j in 0..<items.count-1-i{
                if(items[j].startSection > items[j+1].startSection){
                    let temp = items[j]
                    items[j] = items[j+1]
                    items[j+1] = temp
                    bool = false
                }
                m+=1
            }
            n+=1
            if(bool){
                break
            }
        }
        //每周给课程排序
        for i in 0..<items.count{
            var bool = true
            var m:Int = 0
            var n:Int = 0
            for j in 0..<items.count-1-i{
                if(items[j].dayOfWeek > items[j+1].dayOfWeek){
                    let temp = items[j]
                    items[j] = items[j+1]
                    items[j+1] = temp
                    bool = false
                }
                m+=1
            }
            n+=1
            if(bool){
                break
            }
        }
//        items = items.sorted(by:{$0.startSection > $1.startSection})
        
    }
    
    fileprivate func registerCell() {
        
        let nib = UINib(nibName: String(describing: CourseCollectionViewCell.self), bundle: nil)
        collectionView?.register(nib, forCellWithReuseIdentifier: String(describing: CourseCollectionViewCell.self))
    }
    
    fileprivate func fillCellIsOpenArray() {
        //注册Cell 的打开状态，初始化全为 False
        cellsIsOpen = Array(repeating: false, count: items.count)
//        print(cellsIsOpen)
    }
    
    fileprivate func closeOthersCell(activeIndex: Int) {
        //注册Cell 的打开状态，初始化全为 False
        cellsIsOpen[activeIndex] = false
//        print(cellsIsOpen)
    }
    
    fileprivate func getViewController() -> ExpandingTableViewController {
        let storyboard = UIStoryboard(storyboard: .Main)
        let toViewController: CourseDetailViewController = storyboard.instantiateViewController()
        return toViewController
    }

    //设置导航栏（左边按钮
    fileprivate func configureNavBar() {
//        navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
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
        let info = items[index]
//        let preInfo = items[index-1]
//        print(info)
        //赋值给Cell
        cell.backgroundImageView?.image = UIImage(named: info.imageName)
        cell.courseTitle.text = info.course
        cell.teacherName.text = info.teacher
        switch info.dayOfWeek {
        case 1  :
            cell.weekText.text = "星期一"
        case 2  :
            cell.weekText.text = "星期二"
        case 3  :
            cell.weekText.text = "星期三"
        case 4  :
            cell.weekText.text = "星期四"
        case 5  :
            cell.weekText.text = "星期五"
        case 6  :
            cell.weekText.text = "星期六"
        case 7  :
            cell.weekText.text = "星期日"
        default :
            cell.weekText.text = "暂无数据"
        }
//        switch preInfo.dayOfWeek {
//        case 1  :
//            weekTabel.text = "星期一"
//        case 2  :
//            weekTabel.text = "星期二"
//        case 3  :
//            weekTabel.text = "星期三"
//        case 4  :
//            weekTabel.text = "星期四"
//        case 5  :
//            weekTabel.text = "星期五"
//        case 6  :
//            weekTabel.text = "星期六"
//        case 7  :
//            weekTabel.text = "星期日"
//        default :
//            weekTabel.text = "暂无数据"
//        }
//        cell.weekText.text = String(info.dayOfWeek)
        cell.section.text = String(info.startSection)+"-"+String(info.startSection+info.totalSection-1)+"节"
        cell.SEWeek.text = "第"+String(info.startWeek)+"-"+String(info.endWeek)+"周"
        cell.place.text = info.place
        cell.cellIsOpen(cellsIsOpen[index], animated: false)
//        print(cellsIsOpen)
    }
    
    //Ending Displaying
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        super.collectionView(collectionView, didEndDisplaying: cell, forItemAt: indexPath)
        guard let cell = cell as? CourseCollectionViewCell else { return }
//        print(cell)
        cell.cellIsOpen(false, animated: false)
        print(cell.isOpened)
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

// MARK: UIScrollViewDelegate
extension MainViewController {
    
    func scrollViewDidScroll(_: UIScrollView) {
        print(currentIndex)
//        let info = items[currentIndex]
//        switch info.dayOfWeek {
//        case 1  :
//            weekTabel.text = "星期一"
//        case 2  :
//            weekTabel.text = "星期二"
//        case 3  :
//            weekTabel.text = "星期三"
//        case 4  :
//            weekTabel.text = "星期四"
//        case 5  :
//            weekTabel.text = "星期五"
//        case 6  :
//            weekTabel.text = "星期六"
//        case 7  :
//            weekTabel.text = "星期日"
//        default :
//            weekTabel.text = "暂无数据"
//        }
//        weekTabel.text = "\(currentIndex + 1)/\(items.count)"
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

