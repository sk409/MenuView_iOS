import UIKit

open class MenuView: UIScrollView {
    
    public enum State {
        case opening
        case opened
        case closing
        case closed
    }
    
    open weak var menuViewDataSource: MenuViewDataSource?
    open weak var menuViewDelegate: MenuViewDelegate?
    
    open var state = State.closed
    
    private let menuItemsStackView = UIStackView()
    
    public init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        loadData()
    }
    
    open func reloadData() {
        menuItemsStackView.arrangedSubviews.forEach { arrangedSubview in
            menuItemsStackView.removeArrangedSubview(arrangedSubview)
            arrangedSubview.removeFromSuperview()
        }
        loadData()
    }
    
    private func setupViews() {
        addSubview(menuItemsStackView)
        menuItemsStackView.axis = .vertical
        menuItemsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuItemsStackView.leadingAnchor.constraint(
                equalTo: contentLayoutGuide.leadingAnchor
            ),
            menuItemsStackView.topAnchor.constraint(
                equalTo: contentLayoutGuide.topAnchor
            ),
            menuItemsStackView.bottomAnchor.constraint(
                equalTo: contentLayoutGuide.bottomAnchor
            ),
            menuItemsStackView.widthAnchor.constraint(
                equalTo: frameLayoutGuide.widthAnchor
            ),
        ])
    }
    
    private func loadData() {
        guard let menuViewDataSource = menuViewDataSource else {
            return
        }
        let numberOfSections = menuViewDataSource.numberOfSections(in: self)
        for section in 0..<numberOfSections {
            if let dividerForSection = menuViewDataSource.menuView(
                self,
                dividerForSectionAt: section
            ) {
                menuItemsStackView.addArrangedSubview(dividerForSection)
            }
            let menuSectionView = MenuSectionView()
            let menuSectionHeaderView = menuViewDataSource.menuView(
                self,
                headerForSectionAt: section
            )
            let menuSectionHeaderHeight = menuViewDataSource.menuView(
                self,
                heightForHeaderInSection: section
            )
            let menuSectionHeaderInsets = menuViewDataSource.menuView(
                self,
                insetsForHeaderInSection: section
            )
            menuSectionView.set(
                headerView: menuSectionHeaderView,
                height: menuSectionHeaderHeight,
                insets: menuSectionHeaderInsets
            )
            menuItemsStackView.addArrangedSubview(menuSectionView)
            let numberOfItems = menuViewDataSource.menuView(
                self, numberOfItemsInSection: section
            )
            for item in 0..<numberOfItems {
                if let dividerForItem = menuViewDataSource.menuView(
                    self,
                    dividerForItemAt: IndexPath(item: item, section: section)
                ) {
                    menuSectionView.append(divider: dividerForItem)
                }
                let menuItemViewIndexPath = IndexPath(item: item, section: section)
                let menuItemView = menuViewDataSource.menuView(
                    self,
                    itemAt: menuItemViewIndexPath
                )
                menuItemView.indexPath = menuItemViewIndexPath
                menuItemView.addGestureRecognizer(UITapGestureRecognizer(
                    target: self,
                    action: #selector(handleMenuItemViewTapEvent))
                )
                let menuItemViewHeight = menuViewDataSource.menuView(
                    self,
                    heightForItemAt: menuItemViewIndexPath
                )
                let menuItemViewInsets = menuViewDataSource.menuView(
                    self,
                    insetsForItemAt: menuItemViewIndexPath
                )
                menuSectionView.append(
                    menuItemView: menuItemView,
                    height: menuItemViewHeight,
                    insets: menuItemViewInsets
                )
            }
        }
    }

    @objc
    private func handleMenuItemViewTapEvent(sender: UITapGestureRecognizer) {
        guard let menuViewDelegate = menuViewDelegate else {
            return
        }
        guard let indexPath = (sender.view as? MenuItemView)?.indexPath else {
            return
        }
        menuViewDelegate.menuView(self, didSelectItemAt: indexPath)
    }
}
