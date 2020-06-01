import UIKit

protocol MenuViewDelegate {
    
    func menuView(
        _ menuView: MenuView,
        headerForSectionAt section: Int
    ) -> MenuSectionHeaderView?

    func menuView(
        _ menuView: MenuView,
        dividerForSectionAt section: Int
    ) -> UIView?
    
    func menuView(
        _ menuView: MenuView,
        dividerForItemAt indexPath: IndexPath
    ) -> UIView?
    
    func menuView(
        _ menuView: MenuView,
        didSelectItemAt indexPath: IndexPath
    )
}

extension MenuViewDelegate {
    
    func menuView(
        _ menuView: MenuView,
        headerForSectionAt section: Int
    ) -> MenuSectionHeaderView? {
        return nil
    }

    func menuView(
        _ menuView: MenuView,
        dividerForSectionAt section: Int
    ) -> UIView? {
        guard section != 0 else {
            return nil
        }
        let dividerView = UIView()
        dividerView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        dividerView.heightAnchor.constraint(
            equalToConstant: 1
        ).isActive = true
        return dividerView
    }
    
    func menuView(
        _ menuView: MenuView,
        dividerForItemAt indexPath: IndexPath
    ) -> UIView? {
        return nil
    }
}
