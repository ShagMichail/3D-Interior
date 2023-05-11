//
//  GroopCell.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 13.09.2022.
//

import UIKit
import SnapKit

final class ListViewCell: UITableViewCell {

    
    //MARK: -
    
    private struct Constants {
        static let labelPosition: CGFloat = 20
        static let imageFromLeftRight: CGFloat = 12
        static let imageFromTopBottom: CGFloat = 5
    }
    
    static let identifier = "CustomGroopTableViewCell"
    private let container = UIView()
    private let gradient = CAGradientLayer()

    private let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    
    //MARK: -
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .default
        contentView.backgroundColor = .clear
        
        setupViews()
        setupGradient()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }

    func configure(with data: Room) {
        nameLabel.text = data.name
        nameLabel.font = .systemFont(ofSize: 30)
        
//        mainImageView.image = UIImage(named: "badroom")
//        mainImageView.sizeToFit()
    }
    
    func getImageView() -> UIImageView {
        return mainImageView
    }
    
    private func setupViews() {
        addSubview(mainImageView)
        mainImageView.addSubview(container)
        container.layer.addSublayer(gradient)
        mainImageView.addSubview(nameLabel)
    }
    
    private func setupGradient() {
        gradient.colors = [UIColor.black.withAlphaComponent(1.0).cgColor,
                                UIColor.black.withAlphaComponent(0.0).cgColor]
        gradient.locations = [0.0, 0.35]
        gradient.bounds = bounds.insetBy(dx: -0.5 * bounds.size.width, dy: -0.5 * bounds.size.height)
        gradient.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: -1, b: 0, c: 0, d: -5.8, tx: 1, ty: 3.4))
        gradient.position = center
        gradient.cornerRadius = layer.cornerRadius
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
    }
    
    private func setupLayout() {
        
        mainImageView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(safeAreaLayoutGuide).inset(10)
        }
        container.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(mainImageView)
        }
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(mainImageView).inset(20)
            $0.bottom.equalTo(mainImageView).inset(20)
        }
    }
}
