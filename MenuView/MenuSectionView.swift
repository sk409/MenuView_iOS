import UIKit

class MenuSectionView: UIStackView {
    
    enum State {
        case opening
        case opened
        case closing
        case closed
    }
    
    let iconImageView = UIImageView()
    let titleLabel = UILabel()
    
    private(set) var state = State.closed
    
    private var itemsStackViewHeightConstraint: NSLayoutConstraint?
    private var menuItemViewPositionConstraintsWhenCollapsing = [NSLayoutConstraint]()
    private var menuItemViewPositionConstraintsWhenOpening = [NSLayoutConstraint]()
    private var menuItemViewHeightConstraintsWhenCollapsing = [NSLayoutConstraint]()
    private var menuItemViewHeightConstraintsWhenOpening = [NSLayoutConstraint]()
    private var headerView: MenuSectionHeaderView?
    private let headerViewContainerView = UIView()
    private let itemsStackView = UIStackView()
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(
        headerView: MenuSectionHeaderView?,
        height: CGFloat,
        insets: UIEdgeInsets
    ) {
        if let headerView = self.headerView {
            headerView.removeFromSuperview()
        }
        removeArrangedSubview(headerViewContainerView)
        headerViewContainerView.removeFromSuperview()
        itemsStackViewHeightConstraint?.isActive = headerView?.collapsable ?? true
        self.headerView = headerView
        guard let headerView = headerView else {
            return
        }
        insertArrangedSubview(headerViewContainerView, at: 0)
        headerViewContainerView.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(
                equalTo: headerViewContainerView.safeAreaLayoutGuide.leadingAnchor,
                constant: insets.left
            ),
            headerView.trailingAnchor.constraint(
                equalTo: headerViewContainerView.safeAreaLayoutGuide.trailingAnchor,
                constant: -insets.right
            ),
            headerView.topAnchor.constraint(
                equalTo: headerViewContainerView.safeAreaLayoutGuide.topAnchor,
                constant: insets.top
            ),
            headerView.bottomAnchor.constraint(
                equalTo: headerViewContainerView.safeAreaLayoutGuide.bottomAnchor,
                constant: -insets.bottom
            ),
            headerView.heightAnchor.constraint(equalToConstant: height)
        ])
        headerView.collapserButton.addTarget(
            self,
            action: #selector(handleCollapserButtonTouchUpInsideEvent),
            for: .touchUpInside
        )
    }
    
    func append(divider: UIView) {
        itemsStackView.addArrangedSubview(divider)
    }
    
    func append(
        menuItemView: MenuItemView,
        height: CGFloat,
        insets: UIEdgeInsets
    ) {
        let menuItemViewContainerView = UIView()
        itemsStackView.addArrangedSubview(menuItemViewContainerView)
        menuItemViewContainerView.addSubview(menuItemView)
        let menuItemViewLeadingConstraintWhenOpening = menuItemView.leadingAnchor.constraint(
            equalTo: menuItemViewContainerView.safeAreaLayoutGuide.leadingAnchor,
            constant: insets.left
        )
        let menuItemViewTrailingConstraintWhenOpening = menuItemView.trailingAnchor.constraint(
            equalTo: menuItemViewContainerView.safeAreaLayoutGuide.trailingAnchor,
            constant: -insets.right
        )
        let menuItemViewTopConstraintWhenOpening = menuItemView.topAnchor.constraint(
            equalTo: menuItemViewContainerView.safeAreaLayoutGuide.topAnchor,
            constant: insets.top
        )
        let menuItemViewBottomConstraintWhenOpening = menuItemView.bottomAnchor.constraint(
            equalTo: menuItemViewContainerView.safeAreaLayoutGuide.bottomAnchor,
            constant: -insets.bottom
        )
        menuItemViewPositionConstraintsWhenOpening.append(contentsOf:[
            menuItemViewLeadingConstraintWhenOpening,
            menuItemViewTrailingConstraintWhenOpening,
            menuItemViewTopConstraintWhenOpening,
            menuItemViewBottomConstraintWhenOpening
        ])
        let menuItemViewLeadingConstraintWhenCollapsing = menuItemView.leadingAnchor.constraint(
            equalTo: menuItemViewContainerView.safeAreaLayoutGuide.leadingAnchor
        )
        let menuItemViewTrailingConstraintWhenCollapsing = menuItemView.trailingAnchor.constraint(
            equalTo: menuItemViewContainerView.safeAreaLayoutGuide.trailingAnchor
        )
        let menuItemViewTopConstraintWhenCollapsing = menuItemView.topAnchor.constraint(
            equalTo: menuItemViewContainerView.safeAreaLayoutGuide.topAnchor
        )
        let menuItemViewBottomConstraintWhenCollapsing = menuItemView.bottomAnchor.constraint(
            equalTo: menuItemViewContainerView.safeAreaLayoutGuide.bottomAnchor
        )
        menuItemViewPositionConstraintsWhenCollapsing.append(contentsOf: [
            menuItemViewLeadingConstraintWhenCollapsing,
            menuItemViewTrailingConstraintWhenCollapsing,
            menuItemViewTopConstraintWhenCollapsing,
            menuItemViewBottomConstraintWhenCollapsing
        ])
        let menuItemViewHeightConstraintWhenOpening = menuItemView.heightAnchor.constraint(
            equalToConstant: height
        )
        menuItemViewHeightConstraintsWhenOpening.append(menuItemViewHeightConstraintWhenOpening)
        let menuItemViewHeightConstraintWhenCollapsing = menuItemView.heightAnchor.constraint(
            equalToConstant: 0
        )
        menuItemViewHeightConstraintsWhenCollapsing.append(menuItemViewHeightConstraintWhenCollapsing)
        menuItemView.translatesAutoresizingMaskIntoConstraints = false
        if headerView?.collapserButton.isHidden ?? true {
            NSLayoutConstraint.activate([
                menuItemViewLeadingConstraintWhenOpening,
                menuItemViewTrailingConstraintWhenOpening,
                menuItemViewTopConstraintWhenOpening,
                menuItemViewBottomConstraintWhenOpening,
                menuItemViewHeightConstraintWhenOpening,
            ])
        } else {
            NSLayoutConstraint.activate([
                menuItemViewLeadingConstraintWhenCollapsing,
                menuItemViewTrailingConstraintWhenCollapsing,
                menuItemViewTopConstraintWhenCollapsing,
                menuItemViewBottomConstraintWhenCollapsing,
                menuItemViewHeightConstraintWhenCollapsing,
            ])
        }
    }
    
    private func setupViews() {
        axis = .vertical
        
        addArrangedSubview(itemsStackView)
        
        headerViewContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        itemsStackView.axis = .vertical
        itemsStackViewHeightConstraint = itemsStackView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    @objc
    private func handleCollapserButtonTouchUpInsideEvent() {
        guard state == .opened || state == .closed else {
            return
        }
        guard let itemsStackViewHeightConstraint = itemsStackViewHeightConstraint else {
            return
        }
        if state == .opened {
            menuItemViewPositionConstraintsWhenOpening.forEach{$0.isActive = false}
            menuItemViewPositionConstraintsWhenCollapsing.forEach{$0.isActive = true}
            menuItemViewHeightConstraintsWhenOpening.forEach{$0.isActive = false}
            menuItemViewHeightConstraintsWhenCollapsing.forEach{$0.isActive = true}
            itemsStackViewHeightConstraint.isActive = true
        } else {
            itemsStackViewHeightConstraint.isActive = false
            menuItemViewHeightConstraintsWhenCollapsing.forEach{$0.isActive = false}
            menuItemViewHeightConstraintsWhenOpening.forEach{$0.isActive = true}
            menuItemViewPositionConstraintsWhenCollapsing.forEach{$0.isActive = false}
            menuItemViewPositionConstraintsWhenOpening.forEach{$0.isActive = true}
        }
        let collapserButtonImage = state == .opened ? UIImage(named: "menu") : UIImage(named: "menu-open")
        headerView?.collapserButton.setImage(collapserButtonImage, for: .normal)
        state = state == .opened ? .closing : .opening
        UIView.animate(withDuration: 0.25, animations: {
            self.superview?.superview?.layoutIfNeeded()
        }) { finished in
            if finished {
                self.state = self.state == .opening ? .opened : .closed
            } else {
                self.state = self.state == .opening ? .closed : .opened
            }
        }
    }
    
}
