import UIKit

public protocol MenuViewDataSource: NSObjectProtocol {
    func numberOfSections(
        in menuView: MenuView
    ) -> Int
    
    func menuView(
        _ menuView: MenuView,
        numberOfItemsInSection section: Int
    ) -> Int
    
    func menuView(
        _ menuView: MenuView,
        itemAt indexPath: IndexPath
    ) -> MenuItemView
    
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
        heightForHeaderInSection section: Int
    ) -> CGFloat
    
    func menuView(
        _ menuView: MenuView,
        heightForItemAt indexPath: IndexPath
    ) -> CGFloat
}

extension MenuViewDataSource {
    
    func numberOfSections(in menuView: MenuView) -> Int {
        return 1
    }
    
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
    
    func menuView(
        _ menuView: MenuView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        return 52
    }
    
    func menuView(
        _ menuView: MenuView,
        heightForItemAt indexPath: IndexPath
    ) -> CGFloat {
        return 52
    }
}
