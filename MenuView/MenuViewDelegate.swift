import UIKit

protocol MenuViewDelegate {
    func menuView(_ menuView: MenuView, dividerFor: MenuItemView) -> UIView
}

extension MenuViewDelegate {
    func menuView(_ menuView: MenuView, dividerFor: MenuItemView) -> UIView {
        let dividerView = UIView()
        dividerView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        dividerView.heightAnchor.constraint(
            equalToConstant: 1
        ).isActive = true
        return dividerView
    }
}

struct DefaultMenuViewDelegate: MenuViewDelegate {
}
