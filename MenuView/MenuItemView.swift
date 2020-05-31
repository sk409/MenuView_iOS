import UIKit

class MenuItemView: UIView {
    
    let titleLabel = UILabel()
    let iconImageView = UIImageView()
    let contentsStackView = UIStackView()
    var indexPath: IndexPath?
    
    init (
        title: String,
        iconImage: UIImage?,
        height: CGFloat = 44,
        insets: UIEdgeInsets = .zero
    ) {
        super.init(frame: .zero)
        setupViews(
            title: title,
            iconImage: iconImage,
            height: height,
            insets: insets
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(
        title: String,
        iconImage: UIImage?,
        height: CGFloat,
        insets: UIEdgeInsets
    ) {
        addSubview(contentsStackView)
        contentsStackView.addArrangedSubview(iconImageView)
        contentsStackView.addArrangedSubview(titleLabel)
        
        contentsStackView.alignment = .center
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
            ),
            contentsStackView.heightAnchor.constraint(
                equalToConstant: height
            )
        ])
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.image = iconImage
        iconImageView.isHidden = iconImage == nil
        iconImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(
                equalTo: iconImageView.heightAnchor
            ),
            iconImageView.heightAnchor.constraint(lessThanOrEqualToConstant: 32)
        ])
        
        titleLabel.text = title
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: height)
        ])
    }
}
