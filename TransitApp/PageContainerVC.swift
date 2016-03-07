//
//  PageContainerVC.swift
//  TransitApp
//
//  Created by Elliott Brunet on 06/03/16.
//  Copyright © 2016 Elliott Brunet. All rights reserved.
//

import UIKit

protocol PageContainerVCDelegate : class {
    func routeHasChanged(newRouteIndex: Int)
}

class PageContainerVC: UIViewController {
    
    //MARK: - Properties
    
    private var pageViewController: UIPageViewController!
    
    var selectedRoute : Int! {
        didSet {
            count = selectedRoute
        }
    }

    //we use weak to avoid strong referencing cycle, hence we need to make PageContainerVCDelegate a class protocol
    weak var delegate: PageContainerVCDelegate?
    
    var routes = [Route](){
        didSet{

        }
    }
    
    //keep track of page index, otherwise wierd stuff, got to play around with that...
    private var count = Int(){
        didSet{
            if count <= routes.count - 1 && count >= 0 {
                self.delegate?.routeHasChanged(count)
            }
        }
    }
    
    //MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        let startVC = self.viewControllerAtIndex(selectedRoute) as DetailRouteContentVC
        let viewControllers = NSArray(object: startVC)
        self.pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: .Forward, animated: true, completion: nil)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - PageView Mehtods
    
    //Instantiate controller for pageview
    private func viewControllerAtIndex(index: Int) -> DetailRouteContentVC
    {
        if ((self.routes.count == 0) || (index >= self.routes.count)) {
            return DetailRouteContentVC()
        }
        let vc: DetailRouteContentVC = self.storyboard?.instantiateViewControllerWithIdentifier("ContentViewController") as! DetailRouteContentVC

        vc.pageIndex = index
        vc.routes = routes
        vc.specificRoute = routes[index]
        
        return vc
    }
    
    private func keepCountPlus()
    {
        count++
    }
    
    private func keepCountMinus()
    {
        count--
    }


}

//MARK: - UIPageViewControllerDataSource

extension PageContainerVC: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        let vc = viewController as! DetailRouteContentVC
        var index = vc.pageIndex as Int
        if (index == 0 || index == NSNotFound) { count = 0 ; return nil }
        index--
        
        keepCountMinus()
        
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        let vc = viewController as! DetailRouteContentVC
        var index = vc.pageIndex as Int
        if (index == NSNotFound){ return nil }
        index++
        
        keepCountPlus()
        
        if (index == routes.count) { self.delegate?.routeHasChanged(routes.count-1) ; return nil }
        return self.viewControllerAtIndex(index)
    }
    
   
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return routes.count
    }    
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return selectedRoute
    }
    
}
