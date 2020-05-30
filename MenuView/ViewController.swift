//
//  ViewController.swift
//  MenuView
//
//  Created by 小林聖人 on 2020/05/29.
//  Copyright © 2020 小林聖人. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let button = UIButton()
    private let menuView: MenuView = MenuView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        view.backgroundColor = .green
        setupSubviews()
    }
    
    
    private func setupSubviews() {
        view.addSubview(menuView)
        view.addSubview(button)
        
        let group_1 = MenuGroupView(
            title: "MenuItem_1",
            menuItemViews: [
                MenuItemView(
                    title: "SubmenuItem_1_1",
                    iconImage: UIImage(named: "book")
                ),
                MenuItemView(
                    title: "SubmenuItem_1_2",
                    iconImage: UIImage(named: "book")
                ),
                MenuItemView(
                    title: "SubmenuItem_1_3",
                    iconImage: UIImage(named: "book")
                ),
                MenuItemView(
                    title: "SubmenuItem_1_4",
                    iconImage: UIImage(named: "book")
                ),
                MenuItemView(
                    title: "SubmenuItem_1_5",
                    iconImage: UIImage(named: "book")
                ),
            ]
        )
        let group_2 = MenuGroupView(title: "MenuItem_2")
        let group_3 = MenuGroupView(title: "MenuItem_3")
        let group_4 = MenuGroupView(title: "MenuItem_4")
        let group_5 = MenuCollapsableGroupView(
            title: "MenuItem_5",
            menuItemViews: [
                MenuItemView(title: "SubmenuItem_5_1"),
                MenuItemView(title: "SubmenuItem_5_2"),
                MenuItemView(title: "SubmenuItem_5_3"),
                MenuItemView(title: "SubmenuItem_5_4"),
                MenuItemView(title: "SubmenuItem_5_5"),
                MenuItemView(title: "SubmenuItem_5_6"),
            ],
            open: false
        )
        let group_6 = MenuCollapsableGroupView(
            title: "MenuItem_6",
            menuItemViews: [
                MenuItemView(title: "SubmenuItem_6_1"),
                MenuItemView(title: "SubmenuItem_6_2"),
                MenuItemView(title: "SubmenuItem_6_3"),
                MenuItemView(title: "SubmenuItem_6_4"),
                MenuItemView(title: "SubmenuItem_6_5"),
            ],
            open: true
        )
        menuView.initialize()
        menuView.append(group_1, withDefaultDivider: false)
        menuView.append(group_2)
        menuView.append(group_3)
        menuView.append(group_4)
        menuView.append(group_5)
        menuView.append(group_6)
        
        button.setTitle("Toggle", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(toggle), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
    }
    
    @objc
    private func toggle() {
        _ = menuView.toggle()
    }


}

