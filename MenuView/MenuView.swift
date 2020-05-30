import UIKit

class MenuView: UIScrollView {
    
    enum State {
        case opening
        case opened
        case closing
        case closed
    }
    
    private static func makeDividerView() -> UIView {
        let defaultDividerView = UIView()
        defaultDividerView.backgroundColor = UIColor(
            displayP3Red: 0.91764705882,
            green: 0.91764705882,
            blue: 0.91764705882,
            alpha: 1
        )
        defaultDividerView.translatesAutoresizingMaskIntoConstraints = false
        defaultDividerView.heightAnchor.constraint(
            equalToConstant: 1
        ).isActive = true
        return defaultDividerView
    }
    
    var animationDuration: TimeInterval = 0.25
    var animationDelay: TimeInterval = 0
    var animationOptions: AnimationOptions = [.curveEaseOut]
    var dividerViewFactory = makeDividerView
    var widthMultiplier: CGFloat = 0.65 {
        didSet {
            widthConstraint?.constant = widthMultiplier
        }
    }
    
    private(set) var state = State.closed
    
    private let menuItemsStackView = UIStackView()
    private var trailingConstraint: NSLayoutConstraint?
    private var widthConstraint: NSLayoutConstraint?
    
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
    
    func append(_ menuGroupView: MenuGroupView) {
        append(menuGroupView, withDefaultDivider: true)
    }
    
    func append(_ menuGroupView: MenuGroupView, withDefaultDivider: Bool) {
        if withDefaultDivider {
            menuItemsStackView.addArrangedSubview(dividerViewFactory())
        }
        menuItemsStackView.addArrangedSubview(menuGroupView)
    }
    
    func open() {
        state = .opening
        trailingConstraint?.constant = bounds.width
        UIView.animate(
            withDuration: animationDuration,
            delay: animationDelay,
            options: animationOptions,
            animations: {
                guard let superview = self.superview else {
                    return
                }
                superview.layoutIfNeeded()
        }) { finished in
            self.state = finished ? .opened : .closed
        }
    }
    
    func close() {
        state = .closing
        trailingConstraint?.constant = 0
        UIView.animate(
            withDuration: animationDuration,
            delay: animationDelay,
            options: animationOptions,
            animations: {
                guard let superview = self.superview else {
                    return
                }
                superview.layoutIfNeeded()
        }) { finished in
            self.state = finished ? .closed : .opened
        }
    }
    
    func toggle() -> Bool {
        switch state {
        case .opening:
            return false
        case .opened:
            close()
            return true
        case .closing:
            return false
        case .closed:
            open()
            return true
        }
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
                multiplier: widthMultiplier
            ),
        ])
        
        addSubview(menuItemsStackView)
        menuItemsStackView.axis = .vertical
        menuItemsStackView.alignment = .fill
        menuItemsStackView.distribution = .fill
        menuItemsStackView.translatesAutoresizingMaskIntoConstraints = false
        menuItemsStackView.removeConstraints(menuItemsStackView.constraints)
        NSLayoutConstraint.activate([
            menuItemsStackView.leadingAnchor.constraint(equalTo: contentLayoutGuide.leadingAnchor),
            menuItemsStackView.topAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),
            menuItemsStackView.bottomAnchor.constraint(equalTo: contentLayoutGuide.bottomAnchor),
            menuItemsStackView.widthAnchor.constraint(equalTo: frameLayoutGuide.widthAnchor),
        ])
    }
}
