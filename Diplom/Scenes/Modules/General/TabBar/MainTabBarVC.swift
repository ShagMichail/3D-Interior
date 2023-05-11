//
//  MainTabBarVC.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 14.09.2022.
//

import Foundation
import UIKit

final class MainTabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
        setTabBarApperance()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.SimpleAnnimationWhenSelectItem(item)
    }
    
    private func generateTabBar() {
        viewControllers = [
            generateVC(viewController: UINavigationController(rootViewController: HomeVC()), title: "Начало", image: UIImage(systemName: "house.fill")),
            generateVC(viewController: UINavigationController(rootViewController: ListVC()), title: "Категории", image: UIImage(systemName: "list.bullet.below.rectangle")),
            generateVC(viewController: UINavigationController(rootViewController: AccountVC()), title: "Аккаунт", image: UIImage(systemName: "person.fill")),
        ]
    }
    
    private func generateVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
    }
    
    private func setTabBarApperance() {
        let positionOnX: CGFloat = 10
        let positionOnY: CGFloat = 14
        
        let width = tabBar.bounds.width - positionOnX * 2
        let height = tabBar.bounds.height + positionOnY * 2
        
        let roundLayer = CAShapeLayer()
        
        let bezierPath = UIBezierPath(roundedRect: CGRect(x: positionOnX, y: tabBar.bounds.minX - positionOnY, width: width, height: height), cornerRadius: height/2)
        
        roundLayer.path = bezierPath.cgPath
        tabBar.layer.insertSublayer(roundLayer, at: 0)
        tabBar.itemWidth = width / 5
        tabBar.itemPositioning = .centered
        tabBar.barStyle = .black
        tabBar.backgroundImage = UIImage()
        roundLayer.fillColor = UIColor.systemBlue.cgColor
        
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().unselectedItemTintColor = .white
        
    }
    
    func SimpleAnnimationWhenSelectItem(_ item: UITabBarItem){
        guard let barItemView = item.value(forKey: "view") as? UIView else { return }
        
        let timeInterval: TimeInterval = 0.5
        let propertyAnimator = UIViewPropertyAnimator(duration: timeInterval, dampingRatio: 0.5) {
            barItemView.transform = CGAffineTransform.identity.scaledBy(x: 1.2, y: 1.2)
        }
        propertyAnimator.addAnimations({ barItemView.transform = .identity }, delayFactor: CGFloat(timeInterval))
        propertyAnimator.startAnimation()
    }
    
}
