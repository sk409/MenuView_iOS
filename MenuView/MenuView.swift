import UIKit

class MenuView: UIScrollView {
    
    enum State {
        case opening
        case opened
        case closing
        case closed
    }
    
    var menuViewDataSource: MenuViewDataSource?
    var menuViewDelegate: MenuViewDelegate?
    
    private(set) var state = State.closed
    
    private var leadingConstraint: NSLayoutConstraint?
    private var trailingConstraint: NSLayoutConstraint?
    private let touchGuardView = UIView()
    private let menuItemsStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        setupViews()
        loadData()
    }
    
    func toggle() -> Bool {
        guard state == .opened || state == .closed else {
            return false
        }
        state = state == .opened ? .closing : .opening
        let isOpening = self.state == .opening
        if isOpening {
            trailingConstraint?.isActive.toggle()
            leadingConstraint?.isActive.toggle()
        } else {
            leadingConstraint?.isActive.toggle()
            trailingConstraint?.isActive.toggle()
        }
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.touchGuardView.alpha = isOpening ? 0.8 : 0
                guard let superview = self.superview else {
                    return
                }
                superview.layoutIfNeeded()
        }) { finished in
            if finished {
                self.state = self.state == .opening
                ? .opened
                : .closed
            } else {
                self.state = self.state == .opening
                ? .closed
                : .opened
            }
        }
        return true
    }
    
    private func setupViews() {
        backgroundColor = .white
        
        guard let window = UIApplication.shared.windows.first else {
            return
        }
        
        window.addSubview(touchGuardView)
        window.addSubview(self)
        
        touchGuardView.backgroundColor = UIColor.black
        touchGuardView.alpha = 0
        touchGuardView.addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(handleTouchGuardViewTapEvent))
        )
        touchGuardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            touchGuardView.leadingAnchor.constraint(
                equalTo: window.safeAreaLayoutGuide.leadingAnchor
            ),
            touchGuardView.trailingAnchor.constraint(
                equalTo: window.safeAreaLayoutGuide.trailingAnchor
            ),
            touchGuardView.topAnchor.constraint(
                equalTo: window.safeAreaLayoutGuide.topAnchor
            ),
            touchGuardView.bottomAnchor.constraint(
                equalTo: window.safeAreaLayoutGuide.bottomAnchor
            ),
        ])
        
        translatesAutoresizingMaskIntoConstraints = false
        leadingConstraint = leadingAnchor.constraint(
            equalTo: window.leadingAnchor
        )
        trailingConstraint = trailingAnchor.constraint(
            equalTo: window.leadingAnchor
        )
        NSLayoutConstraint.activate([
            trailingConstraint!,
            topAnchor.constraint(
                equalTo: window.safeAreaLayoutGuide.topAnchor
            ),
            bottomAnchor.constraint(
                equalTo: window.safeAreaLayoutGuide.bottomAnchor
            ),
            widthAnchor.constraint(
                equalTo: window.safeAreaLayoutGuide.widthAnchor,
                multiplier: 0.65
            ),
        ])
        
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
        guard let menuViewDelegate = menuViewDelegate else {
            return
        }
        let numberOfSections = menuViewDataSource.numberOfSections(in: self)
        for section in 0..<numberOfSections {
            if let dividerForSection = menuViewDelegate.menuView(
                self,
                dividerForSectionAt: section
            ) {
                menuItemsStackView.addArrangedSubview(dividerForSection)
            }
            let menuSectionView = MenuSectionView()
            let menuSectionHeaderView = menuViewDelegate.menuView(
                self,
                headerForSectionAt: section
            )
            menuSectionView.initialize(
                headerView: menuSectionHeaderView
            )
            menuItemsStackView.addArrangedSubview(menuSectionView)
            let numberOfItems = menuViewDataSource.menuView(
                self, numberOfItemsInSection: section
            )
            for item in 0..<numberOfItems {
                if let dividerForItem = menuViewDelegate.menuView(
                    self,
                    dividerForItemAt: IndexPath(item: item, section: section)
                ) {
                    menuSectionView.append(divider: dividerForItem)
                }
                let menuItemIndePath = IndexPath(item: item, section: section)
                let menuItemView = menuViewDataSource.menuView(
                    self,
                    itemAt: menuItemIndePath
                )
                menuItemView.indexPath = menuItemIndePath
                menuItemView.addGestureRecognizer(UITapGestureRecognizer(
                    target: self,
                    action: #selector(handleMenuItemViewTapEvent))
                )
                menuSectionView.append(menuItem: menuItemView)
            }
        }
    }
    
    @objc
    private func handleTouchGuardViewTapEvent() {
        _ = toggle()
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
