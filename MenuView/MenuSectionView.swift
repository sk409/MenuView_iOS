import UIKit

class MenuSectionView: UIStackView {
    
    let iconImageView = UIImageView()
    let titleLabel = UILabel()
    
    private var itemsContainerViewHeightConstraint: NSLayoutConstraint?
    private var headerView: MenuSectionHeaderView?
    private let itemsContainerView = MenuSectionItemsContainerView()
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(
        headerView: MenuSectionHeaderView?,
        height: CGFloat
    ) {
        if let headerView = self.headerView {
            removeArrangedSubview(headerView)
            headerView.removeFromSuperview()
        }
        itemsContainerViewHeightConstraint?.isActive = !(headerView?.collapsable ?? false)
        self.headerView = headerView
        guard let headerView = headerView else {
            return
        }
        insertArrangedSubview(headerView, at: 0)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.heightAnchor.constraint(equalToConstant: height)
        ])
        headerView.collapserButton.addTarget(
            self,
            action: #selector(handleCollapserButtonTouchUpInsideEvent),
            for: .touchUpInside
        )
    }
    
    func append(divider: UIView) {
        append(itemView: divider)
    }
    
    func append(
        menuItemView: MenuItemView,
        height: CGFloat
    ) {
        append(itemView: menuItemView)
        menuItemView.heightAnchor.constraint(equalToConstant: height).isActive = true
        itemsContainerViewHeightConstraint?.constant += height
    }
    
    private func setupViews() {
        axis = .vertical
        
        addArrangedSubview(itemsContainerView)
        
        itemsContainerView.clipsToBounds = true
        itemsContainerViewHeightConstraint = itemsContainerView.heightAnchor.constraint(equalToConstant: 0)
    }
    
    private func append(itemView: UIView) {
        let lastItemView = itemsContainerView.subviews.last
        itemsContainerView.addSubview(itemView)
        itemView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            itemView.leadingAnchor.constraint(
                equalTo: itemsContainerView.safeAreaLayoutGuide.leadingAnchor
            ),
            itemView.trailingAnchor.constraint(
                equalTo: itemsContainerView.safeAreaLayoutGuide.trailingAnchor
            ),
        ])
        if let lastItemView = lastItemView {
            itemView.topAnchor.constraint(equalTo: lastItemView.bottomAnchor).isActive = true
        } else {
            itemView.topAnchor.constraint(equalTo: itemsContainerView.topAnchor).isActive = true
        }
    }
    
    @objc
    private func handleCollapserButtonTouchUpInsideEvent() {
        guard itemsContainerView.state == .opened || itemsContainerView.state == .closed else {
            return
        }
        guard let itemsStackViewHeightConstraint = itemsContainerViewHeightConstraint else {
            return
        }
        let collapserButtonImage = itemsContainerView.state == .opened
            ? UIImage(named: "menu")
            : UIImage(named: "menu-open")
        headerView?.collapserButton.setImage(collapserButtonImage, for: .normal)
        itemsContainerView.state = itemsContainerView.state == .opened ? .closing : .opening
        itemsStackViewHeightConstraint.isActive = itemsContainerView.state == .opening
        UIView.animate(withDuration: 0.3, animations: {
            self.superview?.superview?.layoutIfNeeded()
        }) { finished in
            if finished {
                self.itemsContainerView.state = self.itemsContainerView.state == .opening ? .opened : .closed
            } else {
                self.itemsContainerView.state = self.itemsContainerView.state == .opening ? .closed : .opened
            }
        }
    }
    
}
