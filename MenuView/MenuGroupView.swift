import UIKit

class MenuItemView: UIView {
    
    let titleLabel = UILabel()
    var onTouchUpInside: (() -> Void)?
    var iconImage: UIImage? {
        didSet {
            iconImageView.image = iconImage
            iconImageView.isHidden = iconImage == nil
        }
    }
    
    fileprivate let verticalStackView = UIStackView()
    fileprivate let horizontalStackView = UIStackView()
    
    private let iconImageView = UIImageView()
    
    init(
        title: String? = nil,
        itemInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8),
        iconImage: UIImage? = nil,
        height: CGFloat = 44,
        onTouchUpInside: (() -> Void)? = nil
    ) {
        super.init(frame: .zero)
        setupViews(
            title: title,
            itemInsets: itemInsets,
            iconImage: iconImage,
            height: height,
            onTouchUpInside: onTouchUpInside
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(
        title: String?,
        itemInsets: UIEdgeInsets,
        iconImage: UIImage?,
        height: CGFloat,
        onTouchUpInside: (() -> Void)?
    ) {
        self.iconImage = iconImage
        self.onTouchUpInside = onTouchUpInside
        addGestureRecognizer(UITapGestureRecognizer(
            target: self,
            action: #selector(handleTapGesture)
        ))
        
        addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(iconImageView)
        horizontalStackView.addArrangedSubview(titleLabel)
        
        verticalStackView.axis = .vertical
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: itemInsets.left
            ),
            verticalStackView.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor,
                constant: -itemInsets.right
            ),
            verticalStackView.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor,
                constant: itemInsets.top
            ),
            verticalStackView.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor,
                constant: -itemInsets.bottom
            ),
        ])
        
        horizontalStackView.spacing = 8
        horizontalStackView.alignment = .center
        NSLayoutConstraint.activate([
            horizontalStackView.heightAnchor.constraint(equalToConstant: height)
        ])
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(
                equalTo: iconImageView.heightAnchor
            ),
            iconImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 32)
        ])
        
        titleLabel.text = title
    }
    
    @objc
    private func handleTapGesture() {
        onTouchUpInside?()
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
    
    init(
        title: String? = nil,
        itemInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8),
        iconImage: UIImage? = nil,
        menuItemViews: [MenuItemView]? = nil
    ) {
        super.init(title: title, itemInsets: itemInsets, iconImage: iconImage)
        setupViews(menuItemViews: menuItemViews)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(
        menuItemViews: [MenuItemView]?
    ) {
        self.menuItemViews = menuItemViews

        verticalStackView.addArrangedSubview(menuItemStackView)

        menuItemStackView.axis = .vertical
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
        
        horizontalStackView.addArrangedSubview(collapserButton)
        
        let collapserButtonRotationAngle = open
            ? CGFloat.pi/180 * 90
            : 0
        collapserButton.transform = CGAffineTransform(
            rotationAngle: collapserButtonRotationAngle
        )
        collapserButton.setImage(UIImage(
            named: "chevron-right"),
            for: .normal
        )
        collapserButton.setContentHuggingPriority(
            .defaultHigh,
            for: .horizontal
        )
        collapserButton.addTarget(
            self,
            action: #selector(handleCollapserButtonTouchUpInsideEvent),
            for: .touchUpInside
        )
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
