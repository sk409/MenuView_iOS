import UIKit

open class MenuItemView: UIView {
    
    public let titleLabel = UILabel()
    public let iconImageView = UIImageView()
    
    var indexPath: IndexPath?
    
    private let contentsStackView = UIStackView()
    
    public init (
        title: String,
        iconImage: UIImage?,
        insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 4, right: 4)
    ) {
        super.init(frame: .zero)
        setupViews(
            title: title,
            iconImage: iconImage,
            insets: insets
        )
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(
        title: String,
        iconImage: UIImage?,
        insets: UIEdgeInsets
    ) {
        
        addSubview(contentsStackView)
        contentsStackView.addArrangedSubview(iconImageView)
        contentsStackView.addArrangedSubview(titleLabel)

        contentsStackView.spacing = 8
        contentsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentsStackView.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: insets.left
            ),
            contentsStackView.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor,
                constant: -insets.right
            ),
            contentsStackView.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor,
                constant: insets.top
            ),
            contentsStackView.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor,
                constant: -insets.bottom
            )
        ])

        iconImageView.contentMode = .scaleAspectFit
        iconImageView.image = iconImage
        iconImageView.isHidden = iconImage == nil
        iconImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        titleLabel.text = title

    }

}
