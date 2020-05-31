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
    
    private var headerView: MenuSectionHeaderView?
    private let itemsStackView = UIStackView()
    
    func initialize(
        headerView: MenuSectionHeaderView?
    ) {
        axis = .vertical
        self.headerView = headerView
        
        if let headerView = headerView {
            addArrangedSubview(headerView)
        }
        addArrangedSubview(itemsStackView)
        
        itemsStackView.axis = .vertical
        
        headerView?.collapserButton.addTarget(
            self,
            action: #selector(handleCollapserButtonTouchUpInsideEvent),
            for: .touchUpInside
        )
    }
    
    func append(divider: UIView) {
        itemsStackView.addArrangedSubview(divider)
    }
    
    func append(menuItem: MenuItemView) {
        menuItem.isHidden = !(headerView?.collapserButton.isHidden ?? true)
        itemsStackView.addArrangedSubview(menuItem)
    }
    
    @objc
    private func handleCollapserButtonTouchUpInsideEvent() {
        guard state == .opened || state == .closed else {
            return
        }
        state = state == .opened ? .closing : .opening
        UIView.animate(withDuration: 0.25, animations: {
            let rotationAngle = self.state == .opening
                ? CGFloat.pi/180 * 90
                : 0
            self.headerView?.collapserButton.transform = CGAffineTransform(
                rotationAngle: rotationAngle
            )
            self.itemsStackView.arrangedSubviews.forEach { $0.isHidden.toggle() }
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
