//
//  File.swift
//  TMS-uaa
//
//  Created by JoviCheng on 2018/12/12.
//  Copyright © 2018年 JoviCheng. All rights reserved.
//

import UIKit
import expanding_collection

class CourseDetailViewController: ExpandingTableViewController {
    
    fileprivate var scrollOffsetY: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        let image1 = Asset.backgroundImage.image
        print(image1)
        tableView.backgroundView = UIImageView(image: image1)
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
    }
}

// MARK: Helpers

extension CourseDetailViewController {
    
    fileprivate func configureNavBar() {
        navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        navigationItem.rightBarButtonItem?.image = navigationItem.rightBarButtonItem?.image!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    }
}

// MARK: Actions

extension CourseDetailViewController {
    
    @IBAction func backButtonHandler(_: AnyObject) {
        // buttonAnimation
        let viewControllers: [MainViewController?] = navigationController?.viewControllers.map { $0 as? MainViewController } ?? []
        
        for viewController in viewControllers {
            if let rightButton = viewController?.navigationItem.rightBarButtonItem as? AnimatingBarButton {
                rightButton.animationSelected(false)
            }
        }
        popTransitionAnimation()
    }
}

// MARK: UIScrollViewDelegate

extension CourseDetailViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -25 , let navigationController = navigationController {
            // buttonAnimation
            for case let viewController as MainViewController in navigationController.viewControllers {
                if case let rightButton as AnimatingBarButton = viewController.navigationItem.rightBarButtonItem {
                    rightButton.animationSelected(false)
                }
            }
            popTransitionAnimation()
        }
        scrollOffsetY = scrollView.contentOffset.y
    }
}
