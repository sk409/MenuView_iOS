import UIKit

protocol MenuViewDelegate {
    func menuView(_ menuView: MenuView, dividerFor: MenuItemView) -> UIView
}

struct DefaultMenuViewDelegate: MenuViewDelegate {
    
    func menuView(_ menuView: MenuView, dividerFor: MenuItemView) -> UIView {
        let dividerView = UIView()
        let value: CGFloat = 0.8
        dividerView.backgroundColor = UIColor(
            displayP3Red: value,
            green: value,
            blue: value,
            alpha: 1
        )
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        dividerView.heightAnchor.constraint(
            equalToConstant: 1
        ).isActive = true
        return dividerView
    }
}

class MenuView: UIScrollView {
    
    enum State {
        case opening
        case opened
        case closing
        case closed
    }
    
    var menuViewDelegate: MenuViewDelegate = DefaultMenuViewDelegate()
    
    private(set) var state = State.closed
    
    private var trailingConstraint: NSLayoutConstraint?
    private let menuItemStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        backgroundColor = .white
        setupViews()
    }
    
    func append(_ menuItemView: MenuItemView) {
        append(menuItemView, withDivider: true)
    }
    
    func append(_ menuItemView: MenuItemView, withDivider: Bool) {
        if withDivider {
            let dividerView = menuViewDelegate.menuView(self, dividerFor: menuItemView)
            menuItemStackView.addArrangedSubview(dividerView)
        }
        menuItemStackView.addArrangedSubview(menuItemView)
    }
    
    func toggle() -> Bool {
        guard state == .opened || state == .closed else {
            return false
        }
        state = state == .opened ? .closing : .opening
        trailingConstraint?.constant = state == .opening
            ? bounds.width
            : 0
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: .curveEaseOut,
            animations: {
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
        guard let superview = superview else {
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        trailingConstraint = trailingAnchor.constraint(equalTo: superview.leadingAnchor)
        NSLayoutConstraint.activate([
            trailingConstraint!,
            topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor),
            bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor),
            widthAnchor.constraint(
                equalTo: superview.safeAreaLayoutGuide.widthAnchor,
                multiplier: 0.65
            ),
        ])
        
        addSubview(menuItemStackView)
        menuItemStackView.axis = .vertical
        menuItemStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            menuItemStackView.leadingAnchor.constraint(
                equalTo: contentLayoutGuide.leadingAnchor
            ),
            menuItemStackView.topAnchor.constraint(
                equalTo: contentLayoutGuide.topAnchor
            ),
            menuItemStackView.bottomAnchor.constraint(
                equalTo: contentLayoutGuide.bottomAnchor
            ),
            menuItemStackView.widthAnchor.constraint(
                equalTo: frameLayoutGuide.widthAnchor
            ),
        ])
    }
}
