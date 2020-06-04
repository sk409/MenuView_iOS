import UIKit

public protocol MenuViewDelegate: NSObjectProtocol {
    
    func menuView(
        _ menuView: MenuView,
        didSelectItemAt indexPath: IndexPath
    )
}

extension MenuViewDelegate {
}
