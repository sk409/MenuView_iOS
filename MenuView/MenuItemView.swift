import UIKit

open class MenuItemView: UIView {
    
    public let titleLabel = UILabel()
    public let iconImageView = UIImageView()
    
    var indexPath: IndexPath?
    
    private let contentsStackView = UIStackView()
    
    public init (
        title: String,
        iconImage: UIImage?
    ) {
        super.init(frame: .zero)
        setupViews(
            title: title,
            iconImage: iconImage
        )
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(
        title: String,
        iconImage: UIImage?
    ) {
        
        addSubview(contentsStackView)
        contentsStackView.addArrangedSubview(iconImageView)
        contentsStackView.addArrangedSubview(titleLabel)

        contentsStackView.alignment = .center
        contentsStackView.spacing = 8
        contentsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentsStackView.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor
            ),
            contentsStackView.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor
            ),
            contentsStackView.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor
            ),
            contentsStackView.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor
            )
        ])

        iconImageView.contentMode = .scaleAspectFit
        iconImageView.image = iconImage
        iconImageView.isHidden = iconImage == nil
        iconImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        titleLabel.text = title
    
    }

}
