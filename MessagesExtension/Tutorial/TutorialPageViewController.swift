//
//  TutorialPageViewController.swift
//  projectstickers
//
//  Created by William Robinson on 06/11/2016.
//  Copyright © 2016 William Robinson. All rights reserved.
//

import UIKit



class TutorialPageViewController: UIPageViewController {
    

    internal lazy var tutorialViewControllers: [UIViewController] = {
        return [self.viewControllerForIndex(index: 0),
                self.viewControllerForIndex(index: 0),
                self.viewControllerForIndex(index: 0)]
    }()
    
    func viewControllerForIndex(index: Int) -> UIViewController {
        
        return UIStoryboard(name: "Tutorial", bundle: nil).instantiateViewController(withIdentifier:"Page \(index)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        if let firstViewController = tutorialViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        
        style()
    }
    
    func style() {
        let pageControl = UIPageControl.appearance(whenContainedInInstancesOf: [TutorialPageViewController.self])
        pageControl.pageIndicatorTintColor = UIColor.green
        pageControl.currentPageIndicatorTintColor = UIColor.red
    }
}

// MARK: UIPageViewControllerDataSource

extension TutorialPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = tutorialViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let tutorialViewControllersCount = tutorialViewControllers.count
        
        guard tutorialViewControllersCount != nextIndex else {
            return nil
        }
        
        guard tutorialViewControllersCount > nextIndex else {
            return nil
        }
        
        return tutorialViewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = tutorialViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard tutorialViewControllers.count > previousIndex else {
            return nil
        }
        
        return tutorialViewControllers[previousIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return tutorialViewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = tutorialViewControllers.index(of: firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }
}
