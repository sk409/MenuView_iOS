import UIKit

class MenuSectionHeaderView: UIView {
    
    let titleLabel = UILabel()
    let iconImageView = UIImageView()
    let collapserButton = UIButton()
    
    let contentsStackView = UIStackView()
    
    init(
        title: String?,
        iconImage: UIImage?,
        collapsable: Bool,
        height: CGFloat = 44,
        insets: UIEdgeInsets = .zero
    ) {
        super.init(frame: .zero)
        setupViews(
            title: title,
            iconImage: iconImage,
            collapsable: collapsable,
            height: height,
            insets: insets
        )
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(
        title: String?,
        iconImage: UIImage?,
        collapsable: Bool,
        height: CGFloat,
        insets: UIEdgeInsets
    ) {
        addSubview(contentsStackView)
        contentsStackView.addArrangedSubview(iconImageView)
        contentsStackView.addArrangedSubview(titleLabel)
        contentsStackView.addArrangedSubview(collapserButton)
        
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
            contentsStackView.heightAnchor.constraint(equalToConstant: height)
        ])
        
        iconImageView.image = iconImage
        iconImageView.isHidden = iconImage == nil
        iconImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(
                equalTo: iconImageView.heightAnchor
            ),
            iconImageView.heightAnchor.constraint(
                lessThanOrEqualToConstant: 32
            )
        ])
        
        titleLabel.text = title
        titleLabel.isHidden = title == nil
        
        collapserButton.setImage(UIImage(named: "chevron-right"), for: .normal)
        collapserButton.isHidden = !collapsable
        collapserButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
}
