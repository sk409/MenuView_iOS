import UIKit

class MenuItemView: UIView {
    
    let iconImageView = UIImageView()
    let titleLabel = UILabel()
    var action: (() -> Void)?
    var iconImage: UIImage? {
        didSet {
            iconImageView.image = iconImage
            titleLabelLeadingConstraintToHeaderViewLeading?.isActive = iconImage == nil
            titleLabelLeadingConstraintToIconImageViewTrailing?.isActive = iconImage != nil
        }
    }
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    var itemInsets = UIEdgeInsets(
        top: 0,
        left: 4,
        bottom: 0,
        right: 0
    ) {
        didSet {
            // TODO
            setNeedsLayout()
        }
    }
    
    fileprivate let headerView = UIView()
    fileprivate var headerViewBottomConstraint: NSLayoutConstraint?
    
    private var titleLabelLeadingConstraintToHeaderViewLeading: NSLayoutConstraint?
    private var titleLabelLeadingConstraintToIconImageViewTrailing: NSLayoutConstraint?
    
    init(title: String, iconImage: UIImage? = nil) {
        super.init(frame: .zero)
        setupViews(title: title, iconImage: iconImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(title: String? = nil, iconImage: UIImage? = nil) {
        self.iconImage = iconImage
        self.title = title
        addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(handleTapGesture)
        ))
        
        addSubview(headerView)
        headerView.addSubview(iconImageView)
        headerView.addSubview(titleLabel)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerViewBottomConstraint = headerView.bottomAnchor.constraint(
            equalTo: safeAreaLayoutGuide.bottomAnchor
        )
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor
            ),
            headerView.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor
            ),
            headerView.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor
            ),
            headerViewBottomConstraint!,
            headerView.heightAnchor.constraint(
                greaterThanOrEqualToConstant: 44
            )
        ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabelLeadingConstraintToHeaderViewLeading = titleLabel.leadingAnchor.constraint(
            equalTo: headerView.leadingAnchor,
            constant: itemInsets.left
        )
        titleLabelLeadingConstraintToIconImageViewTrailing = titleLabel.leadingAnchor.constraint(
            equalTo: iconImageView.trailingAnchor,
            constant: UIScreen.main.bounds.width * 0.025
        )
        let titleLabelLeadingConstraint = iconImage == nil
            ? titleLabelLeadingConstraintToHeaderViewLeading
            : titleLabelLeadingConstraintToIconImageViewTrailing
        let titleLabelTrailingConstraint = titleLabel.trailingAnchor.constraint(
            equalTo: headerView.trailingAnchor,
            constant: -itemInsets.right
        )
        titleLabelTrailingConstraint.priority = UILayoutPriority.defaultLow
        NSLayoutConstraint.activate([
            titleLabelLeadingConstraint!,
            titleLabelTrailingConstraint,
            titleLabel.topAnchor.constraint(
                equalTo: headerView.topAnchor,
                constant: itemInsets.top
            ),
            titleLabel.bottomAnchor.constraint(
                equalTo: headerView.bottomAnchor,
                constant: -itemInsets.bottom
            )
        ])
        
        let iconHeight = titleLabel.sizeThatFits(
            CGSize(width: CGFloat.infinity, height: .infinity)
        ).height
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: itemInsets.left
            ),
            iconImageView.centerYAnchor.constraint(
                equalTo: safeAreaLayoutGuide.centerYAnchor
            ),
            iconImageView.widthAnchor.constraint(
                equalTo: iconImageView.heightAnchor
            ),
            iconImageView.heightAnchor.constraint(
                equalToConstant: iconHeight
            )
        ])
    }
    
    @objc
    private func handleTapGesture() {
        action?()
    }
}


class MenuGroupView: MenuItemView {
    
    var menuItemViews: ([MenuItemView])? {
        willSet {
            removeMenuItemViews()
        }
        didSet {
            addMenuItemViews()
        }
    }
    
    fileprivate let menuItemStackView = UIStackView()
    
    override init(title: String, iconImage: UIImage? = nil) {
        super.init(title: title, iconImage: iconImage)
    }
    
    init(title: String, menuItemViews: [MenuItemView]) {
        super.init(title: title)
        setupViews(menuItemViews: menuItemViews)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(
        menuItemViews: [MenuItemView]
    ) {
        headerViewBottomConstraint?.isActive = false
        self.menuItemViews = menuItemViews
        
        addSubview(menuItemStackView)
        
        menuItemStackView.distribution = .fill
        menuItemStackView.axis = .vertical
        menuItemStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuItemStackView.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor
            ),
            menuItemStackView.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor
            ),
            menuItemStackView.topAnchor.constraint(
                equalTo: headerView.bottomAnchor
            ),
            menuItemStackView.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor
            ),
        ])
    }
    
    private func addMenuItemViews() {
        menuItemViews?.forEach {menuItemStackView.addArrangedSubview($0)}
    }
    
    private func removeMenuItemViews() {
        menuItemViews?.forEach { menuItemView in
            menuItemStackView.removeArrangedSubview(menuItemView)
            menuItemView.removeFromSuperview()
        }
    }
    
    
}

class MenuCollapsableGroupView: MenuGroupView {
    
    enum State {
        case opening
        case opened
        case closing
        case closed
    }
    
    var collapseAnimationDuration = 0.25
    
    private(set) var state = State.closed
    
    private let collapserButton = UIButton()
    
    init(title: String, menuItemViews: [MenuItemView], open: Bool) {
        super.init(title: title, menuItemViews: menuItemViews)
        setupViews(open: open)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(open: Bool = false) {
        menuItemViews?.forEach { $0.isHidden = !open }
        state = open ? .opened : .closed
        
        headerView.addSubview(collapserButton)
        
        titleLabel.trailingAnchor.constraint(equalTo: collapserButton.leadingAnchor).isActive = true
        
        let collapserButtonRotationAngle = open
            ? CGFloat.pi/180 * 90
            : 0
        collapserButton.transform = CGAffineTransform(
            rotationAngle: collapserButtonRotationAngle
        )
        collapserButton.setImage(UIImage(named: "chevron-right"), for: .normal)
        collapserButton.addTarget(
            self,
            action: #selector(handleCollapserButtonTouchUpInsideEvent),
            for: .touchUpInside
        )
        collapserButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collapserButton.centerYAnchor.constraint(
                equalTo: titleLabel.centerYAnchor
            ),
            collapserButton.trailingAnchor.constraint(
                equalTo: headerView.trailingAnchor,
                constant: -itemInsets.right
            ),
            collapserButton.widthAnchor.constraint(
                equalTo: collapserButton.heightAnchor
            ),
            collapserButton.heightAnchor.constraint(
                greaterThanOrEqualToConstant: 44
            )
        ])
    }
    
    @objc
    private func handleCollapserButtonTouchUpInsideEvent() {
        guard state == .opened || state == .closed else {
            return
        }
        state = state == .opened ? .closing : .opening
        UIView.animate(withDuration: collapseAnimationDuration, animations: {
            let rotationAngle = self.state == .opening
                ? CGFloat.pi/180 * 90
                : 0
            self.collapserButton.transform = CGAffineTransform(
                rotationAngle: rotationAngle
            )
            self.menuItemViews?.forEach { menuItemView in
                menuItemView.isHidden = self.state == .closing
            }
            self.layoutIfNeeded()
        }) { finished in
            if finished {
                self.state = self.state == .opening ? .opened : .closed
            } else {
                self.state = self.state == .opening ? .closed : .opened
            }
        }
    }
    
}
