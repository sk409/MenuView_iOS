import UIKit

public struct MenuItem {
    public var title: String
    public var iconImage: UIImage?
    public var insets: UIEdgeInsets
    public var onTap: (() -> Void)?
    
    public init(
        title: String,
        iconImage: UIImage? = nil,
        insets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8),
        onTap: (() -> Void)? = nil
    ) {
        self.title = title
        self.iconImage = iconImage
        self.insets = insets
        self.onTap = onTap
    }
}
