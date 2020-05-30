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
        
        let menuItemHeight: CGFloat = 44
        
        let menu_1 = MenuItemView(
            title: "MenuItem_1",
            iconImage: UIImage(named: "book"),
            height: menuItemHeight
        )
        let menu_2 = MenuItemView(
            title: "MenuItem_2",
            iconImage: UIImage(named: "book"),
            height: menuItemHeight
        )
        let menu_3 = MenuItemView(
            title: "MenuItem_3",
            iconImage: UIImage(named: "book"),
            height: menuItemHeight
        )
        
        let menu_1_1 = MenuItemView(
            title: "MenuGroup_1_1",
            iconImage: UIImage(named: "book"),
            height: menuItemHeight
        ) {
            print("menu_1_1")
        }
        let menu_1_2 = MenuItemView(
            title: "MenuGroup_1_2",
            iconImage: UIImage(named: "book"),
            height: menuItemHeight
        ) {
            print("menu_1_2")
        }
        let menu_1_3 = MenuItemView(
            title: "MenuGroup_1_3",
            iconImage: UIImage(named: "book"),
            height: menuItemHeight
        ) {
            print("menu_1_3")
        }
        let menu_1_4 = MenuItemView(
            title: "MenuGroup_1_4",
            iconImage: UIImage(named: "book"),
            height: menuItemHeight
        ) {
            print("menu_1_4")
        }
        let menu_1_5 = MenuItemView(
            title: "MenuGroup_1_5",
            iconImage: UIImage(named: "book"),
            height: menuItemHeight
        ) {
            print("menu_1_5")
        }
        let group_1 = MenuGroupView(
            title: "MenuGroup_1",
            menuItemViews: [
                menu_1_1,
                menu_1_2,
                menu_1_3,
                menu_1_4,
                menu_1_5,
            ]
        )
//        let group_2 = MenuGroupView(title: "MenuItem_2")
//        let group_3 = MenuGroupView(title: "MenuItem_3")
//        let group_4 = MenuGroupView(title: "MenuItem_4")
        let menu_5_1 = MenuItemView(
            title: "MenuGroup_5_1",
            iconImage: UIImage(named: "book"),
            height: menuItemHeight
        ) {
            print("menu_5_1")
        }
        let menu_5_2 = MenuItemView(
            title: "MenuGroup_5_2",
            iconImage: UIImage(named: "book"),
            height: menuItemHeight
        ) {
            print("menu_5_2")
        }
        let menu_5_3 = MenuItemView(
            title: "MenuGroup_5_3",
            iconImage: UIImage(named: "book"),
            height: menuItemHeight
        ) {
            print("menu_5_3")
        }
        let menu_5_4 = MenuItemView(
            title: "MenuGroup_5_4",
            iconImage: UIImage(named: "book"),
            height: menuItemHeight
        ) {
            print("menu_5_4")
        }
        let menu_5_5 = MenuItemView(
            title: "MenuGroup_5_5",
            iconImage: UIImage(named: "book"),
            height: menuItemHeight
        ) {
            print("menu_5_5")
        }
        let group_5 = MenuCollapsableGroupView(
            title: "MenuItem_5",
            menuItemViews: [
                menu_5_1,
                menu_5_2,
                menu_5_3,
                menu_5_4,
                menu_5_5,
            ],
            open: false
        )
        let group_6 = MenuCollapsableGroupView(
            title: "MenuGroup_6",
            menuItemViews: [
                MenuItemView(
                    title: "MenuGroup_6_1",
                    height: menuItemHeight
                ),
                MenuItemView(
                    title: "MenuGroup_6_2",
                    height: menuItemHeight
                ),
                MenuItemView(
                    title: "MenuGroup_6_3",
                    height: menuItemHeight
                ),
                MenuItemView(
                    title: "MenuGroup_6_4",
                    height: menuItemHeight
                ),
                MenuItemView(
                    title: "MenuGroup_6_5",
                    height: menuItemHeight
                ),
            ],
            open: true
        )
        menuView.initialize()
        menuView.append(menu_1, withDivider: false)
        menuView.append(menu_2, withDivider: false)
        menuView.append(menu_3, withDivider: false)
        menuView.append(group_1)
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

