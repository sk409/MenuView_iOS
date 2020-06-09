import UIKit

public struct MenuItem {
    public var title: String
    public var iconImage: UIImage?
    public var insets: UIEdgeInsets
    public var onTap: (() -> Void)?
    
    public init(
        title: String,
        iconImage: UIImage? = nil,
        insets: UIEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4),
        onTap: (() -> Void)? = nil
    ) {
        self.title = title
        self.iconImage = iconImage
        self.insets = insets
        self.onTap = onTap
    }
}
