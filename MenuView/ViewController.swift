import UIKit

class ViewController: UIViewController {
        
    private let menuView = MenuView()
    private let label = UILabel()
    private var menuSections = [MenuSection]()
    private var menuViewLeadingConstraint: NSLayoutConstraint?
    private var menuViewTrailingConstraint: NSLayoutConstraint?
    
    private var mode = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .green
        
        let toggleButton = UIButton()
        let reloadButton = UIButton()

        view.addSubview(label)
        view.addSubview(toggleButton)
        view.addSubview(reloadButton)
        view.addSubview(menuView)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Itemを\nタップすると\nここに\nタイトルが\n表示されます"
        label.numberOfLines = 5
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            label.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor
            )
        ])
        
        toggleButton.setTitle("Toggle", for: .normal)
        toggleButton.setTitleColor(.black, for: .normal)
        toggleButton.addTarget(self, action: #selector(toggle), for: .touchUpInside)
        toggleButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toggleButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            toggleButton.bottomAnchor.constraint(equalTo: reloadButton.topAnchor, constant: -16)
        ])
        
        reloadButton.setTitle("Reload", for: .normal)
        reloadButton.setTitleColor(.black, for: .normal)
        reloadButton.addTarget(self, action: #selector(reload), for: .touchUpInside)
        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            reloadButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),
            reloadButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -16
            )
        ])
        
        setupMenuSection()
        menuView.backgroundColor = .white
        menuView.menuViewDataSource = self
        menuView.menuViewDelegate = self
        menuView.reloadData()
        menuViewLeadingConstraint = menuView.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor
        )
        menuViewTrailingConstraint = menuView.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor
        )
        menuView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuViewTrailingConstraint!,
            menuView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            menuView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            ),
            menuView.widthAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.widthAnchor,
                multiplier: 0.6
            ),
        ])
    }
    
    private func setupMenuSection() {
        menuSections.removeAll()
        if mode == 0 {
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
                            self.label.text = title
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
        } else {
            let sections = [12, 4, 4, 3, 5]
            for (i, section) in sections.enumerated() {
                var menuItems = [MenuItem]()
                for j in 0..<section {
                    let title = "Section\(i)_\(j)"
                    menuItems.append(
                        MenuItem(
                            title: title,
                            iconImage: UIImage(named: "book")
                        ) {
                            self.label.text = title
                        }
                    )
                }
                let section = MenuSection(
                    title: "Section\(i)",
                    iconImage: !i.isMultiple(of: 2) ? UIImage(named: "android") : nil,
                    menuItems: menuItems,
                    collapsable: !i.isMultiple(of: 2)
                )
                menuSections.append(section)
            }
        }
        mode = (mode + 1) % 2
    }
    
    @objc
    func toggle() -> Bool {
        guard menuView.state == .opened || menuView.state == .closed else {
            return false
        }
        menuView.state = menuView.state == .opened ? .closing : .opening
        let isOpening = self.menuView.state == .opening
        if isOpening {
            menuViewTrailingConstraint?.isActive.toggle()
            menuViewLeadingConstraint?.isActive.toggle()
        } else {
            menuViewLeadingConstraint?.isActive.toggle()
            menuViewTrailingConstraint?.isActive.toggle()
        }
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.view.layoutIfNeeded()
        }) { finished in
            if finished {
                self.menuView.state = self.menuView.state == .opening
                ? .opened
                : .closed
            } else {
                self.menuView.state = self.menuView.state == .opening
                ? .closed
                : .opened
            }
        }
        return true
    }
    
    @objc
    private func reload() {
        setupMenuSection()
        menuView.reloadData()
    }
    
}

extension ViewController: MenuViewDelegate {
    
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
    
    func menuView(_ menuView: MenuView, heightForHeaderInSection section: Int) -> CGFloat {
        return 52
    }
    
    func menuView(_ menuView: MenuView, heightForItemAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

}
