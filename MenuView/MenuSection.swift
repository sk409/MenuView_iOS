import UIKit

public struct MenuSection {
    public var title: String?
    public var iconImage: UIImage?
    public var menuItems: [MenuItem]
    public var collapsable: Bool
    public var insets: UIEdgeInsets
    
    public init(
        title: String? = nil,
        iconImage: UIImage? = nil,
        menuItems: [MenuItem] = [],
        collapsable: Bool = false,
        insets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    ) {
        self.title = title
        self.iconImage = iconImage
        self.menuItems = menuItems
        self.collapsable = collapsable
        self.insets = insets
    }
}
