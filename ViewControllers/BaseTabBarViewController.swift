//
//  BaseTabBarViewController.swift
//  Swimmy
//
//  Created by 伊藤寛人 on 2021/06/20.
//


import UIKit

class BaseTabBarController: UITabBarController {
    
    enum ControllerName :Int {
        case home,search,post,profile //favorite
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupViewcontrolers()
    }
       
    
    private func setupViewcontrolers() {
        viewControllers?.enumerated().forEach({ (index, viewController) in
            if let name = ControllerName.init(rawValue: index) {
                switch name {
                case .home:
                    setTabbarInfo(viewController, selectedImageName: "home-icon-selected", unselectedImageName: "home-icon-unselected", title: "ホーム")
                    
                case .search:
                    setTabbarInfo(viewController, selectedImageName: "search-icon-selected", unselectedImageName: "search-icon-unselected", title: "検索")
                
                case .post:
                    setTabbarInfo(viewController, selectedImageName: "post-icon-selected", unselectedImageName: "post-icon-unselected", title: "投稿する")
                
//                case .favorite:
//                    setTabbarInfo(viewController, selectedImageName: "favorite-icon-selected", unselectedImageName: "favorite-icon-unselected", title: "お気に入り")
                
                case .profile:
                    setTabbarInfo(viewController, selectedImageName: "profile-icon-selected", unselectedImageName: "profile-icon-unselected", title: "プロフィール")
            
                }
           
            }
        })
        
    }
        
                                              
    
    private func setTabbarInfo(_ viewController: UIViewController, selectedImageName: String, unselectedImageName: String, title: String) {
        viewController.tabBarItem.selectedImage = UIImage(named: selectedImageName)?.resize(size: .init(width: 20, height: 20))?.withRenderingMode(.alwaysOriginal)
        viewController.tabBarItem.image = UIImage(named: unselectedImageName)?.resize(size: .init(width: 20, height: 20))?.withRenderingMode(.alwaysOriginal)
        viewController.tabBarItem.title = title
    }
    
    
}
