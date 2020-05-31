import UIKit

class MenuView: UIScrollView {
    
    enum State {
        case opening
        case opened
        case closing
        case closed
    }
    
    var menuViewDelegate: MenuViewDelegate = DefaultMenuViewDelegate()
    
    private(set) var state = State.closed
    
    private var leadingConstraint: NSLayoutConstraint?
    private var trailingConstraint: NSLayoutConstraint?
    private let touchGuardView = UIView()
    private let menuItemStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
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
    
    @objc
    private func handleTouchGuardViewTapEvent() {
        _ = toggle()
    }
}
