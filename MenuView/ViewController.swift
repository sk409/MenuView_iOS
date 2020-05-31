import UIKit

class ViewController: UIViewController {
    
    private class MenuSection {
        let title: String?
        let iconImage: UIImage?
        let menuItems: [MenuItem]
        let collapsable: Bool
        let insets: UIEdgeInsets
        
        init(
            title: String? = nil,
            iconImage: UIImage? = nil,
            menuItems: [MenuItem] = [],
            collapsable: Bool = false,
            insets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        ) {
            self.title = title
            self.iconImage = iconImage
            self.menuItems = menuItems
            self.collapsable = collapsable
            self.insets = insets
        }
    }
    
    private class MenuItem {
        let title: String
        let iconImage: UIImage?
        let insets: UIEdgeInsets
        let onTap: (() -> Void)?
        
        init(
            title: String,
            iconImage: UIImage? = nil,
            insets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8),
            onTap: (() -> Void)? = nil
        ) {
            self.title = title
            self.iconImage = iconImage
            self.insets = insets
            self.onTap = onTap
        }
    }
    
    private let menuView: MenuView = MenuView()
    private var menuSections = [MenuSection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupMenuView()
    }
    
    
    private func setupViews() {
        view.backgroundColor = .green
        
        let button = UIButton()
        
        view.addSubview(button)
        
        button.setTitle("Open", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(toggle), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        
        let dummy = UIView()
        view.addSubview(dummy)
        dummy.backgroundColor = .orange
        dummy.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dummy.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dummy.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            dummy.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            dummy.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6)
        ])
    }
    
    private func setupMenuView() {
        let sections = [1, 1, 12, 6, 24]
        for (i, section) in sections.enumerated() {
            var menuItems = [MenuItem]()
            for j in 0..<section {
                let title = "Section\(i)_\(j)"
                menuItems.append(
                    MenuItem(
                        title: title,
                        iconImage: UIImage(named: "book")
                    ) {
                        print(title)
                    }
                )
            }
            let section = MenuSection(
                title: "Section\(i)",
                iconImage: i.isMultiple(of: 2) ? UIImage(named: "android") : nil,
                menuItems: menuItems,
                collapsable: i.isMultiple(of: 2)
            )
            menuSections.append(section)
        }
        menuView.menuViewDataSource = self
        menuView.menuViewDelegate = self
        menuView.initialize()
    }
    
    @objc
    private func toggle() {
        _ = menuView.toggle()
    }
    
}

extension ViewController: MenuViewDelegate {
    
    func menuView(
        _ menuView: MenuView,
        headerForSectionAt section: Int
    ) -> MenuSectionHeaderView? {
        let menuSection = menuSections[section]
        guard menuSection.title != nil || menuSection.iconImage != nil else {
            return nil
        }
        let headerView = MenuSectionHeaderView(
            title: menuSection.title,
            iconImage: menuSection.iconImage,
            collapsable: menuSection.collapsable,
            insets: menuSection.insets
        )
        headerView.titleLabel.font = .systemFont(ofSize: 18)
        headerView.titleLabel.textColor = UIColor(white: 0, alpha: 0.6)
        return headerView
    }
    
    func menuView(_ menuView: MenuView, didSelectItemAt indexPath: IndexPath) {
        let menuItem = menuSections[indexPath.section].menuItems[indexPath.item]
        menuItem.onTap?()
    }
}

extension ViewController: MenuViewDataSource {
    
    func numberOfSections(in menuView: MenuView) -> Int {
        return menuSections.count
    }
    
    func menuView(_ menuView: MenuView, numberOfItemsInSection section: Int) -> Int {
        return menuSections[section].menuItems.count
    }
    
    func menuView(_ menuView: MenuView, itemAt indexPath: IndexPath) -> MenuItemView {
        let menuItem = menuSections[indexPath.section].menuItems[indexPath.item]
        let menuItemView = MenuItemView(
            title: menuItem.title,
            iconImage: menuItem.iconImage,
            insets: menuItem.insets
        )
        return menuItemView
    }
}
