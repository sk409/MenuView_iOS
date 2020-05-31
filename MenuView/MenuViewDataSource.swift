import UIKit

protocol MenuViewDataSource {
    func numberOfSections(in menuView: MenuView) -> Int
    func menuView(_ menuView: MenuView, numberOfItemsInSection section: Int) -> Int
    func menuView(_ menuView: MenuView, itemAt indexPath: IndexPath) -> MenuItemView
}

extension MenuViewDataSource {
    
    func numberOfSections(in menuView: MenuView) -> Int {
        return 1
    }
    
    func menuView(_ menuView: MenuView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }
    
    func menuView(_ menuView: MenuView, iconForHeaderInSection section: Int) -> UIImage? {
        return nil
    }
}
