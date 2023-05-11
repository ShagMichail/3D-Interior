//
//  InfoView.swift
//  Diplom
//
//  Created by Михаил Шаговитов on 26.01.2023.
//

import UIKit
import SnapKit

protocol InfoViewDelegate: AnyObject {
    func didTapMenuButton()
}

final class InfoView: UIView {
    
    weak var delegate: InfoViewDelegate?
    
    lazy var headerView: CustomHeader = {
        var view = CustomHeader()
        view.navTitle.text = "О нас"
        view.basketButton.removeFromSuperview()
        view.backgroundColor = .systemBlue
        return view
    }()
    
//    private var contentCize: CGSize {
//        CGSize(width: frame.width, height: frame.height + 400)
//    }
    
    lazy var scrollView: UIScrollView = {
        var scroll = UIScrollView()
        //scroll.frame = bounds
        //scroll.contentSize = contentCize
        scroll.alwaysBounceVertical = true
        scroll.alwaysBounceHorizontal = false
        scroll.showsVerticalScrollIndicator = false
//        scroll.clipsToBounds = true
        return scroll
    }()
    
    lazy var contentScrollView: UIView = {
        var view = UIView()
        //view.frame.size = contentCize
        return view
    }()
    
    lazy var line1: UIView = {
        var view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    lazy var line2: UIView = {
        var view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    lazy var entranceLabel1: UILabel = {
        var label = UILabel()
        label.text = "Фабрика «Смоленскмебель» работает на мебельном рынке России и СНГ с 1954 года, являясь стабильным производителем кухонь, прихожих и ряда другой мебели."
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .justified
        label.numberOfLines = 0
        return label
    }()
    
    lazy var entranceLabel2: UILabel = {
        var label = UILabel()
        label.text = "Фабрика находится в 378 км от Москвы, в г. Смоленск, в трех километрах от трассы Москва-Минск."
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .justified
        label.numberOfLines = 0
        return label
    }()
    
    lazy var entranceLabel3: UILabel = {
        var label = UILabel()
        label.text = "Фабрика использует опыт и традиции качества потомственных мебельщиков и новейшие технологии, отработанные с ведущими западными компаниями и входит в Группу компаний «Евродизайн»."
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .justified
        label.numberOfLines = 5
        return label
    }()
    
    lazy var entranceLabel4: UILabel = {
        var label = UILabel()
        label.text = "Собственная торговая марка - Goodline/Гудлайн."
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .justified
        label.numberOfLines = 0
        return label
    }()
    
    lazy var entranceLabel5: UILabel = {
        var label = UILabel()
        label.text = "В работе АО «Смоленскмебель» учитываются 4 основополагающих принципа:"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .justified
        label.numberOfLines = 0
        return label
    }()
    
    lazy var entranceLabel6: UILabel = {
        var label = UILabel()
        label.text = "- полный цикл высококачественного производства от ламинирования до обработки высокоглянцевых покрытий для фасадов мебели;"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .justified
        label.numberOfLines = 0
        return label
    }()
    
    lazy var entranceLabel7: UILabel = {
        var label = UILabel()
        label.text = "- доступная для массового покупателя стоимость, как результат многолетних поставок в крупнейшие федеральные и региональные сети;"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .justified
        label.numberOfLines = 0
        return label
    }()
    
    lazy var entranceLabel8: UILabel = {
        var label = UILabel()
        label.text = "- высокая квалификация специалистов всех уровней;"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .justified
        label.numberOfLines = 0
        return label
    }()
    
    lazy var entranceLabel9: UILabel = {
        var label = UILabel()
        label.text = "- непрерывное внимательное отношение к клиентам."
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .justified
        label.numberOfLines = 0
        return label
    }()
    
    lazy var entranceLabel10: UILabel = {
        var label = UILabel()
        label.text = "Наша Миссия: «Комфорт и удобство в деталях мебели по фабричным ценам»."
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .justified
        label.numberOfLines = 0
        return label
    }()
    
    required init(delegate: InfoViewDelegate) {
        super.init(frame: .zero)
        addSubviews()
        makeConstraints()
        setupElement()
        
        self.delegate = delegate
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupElement() {
        headerView.backButton.addTarget(self, action: #selector(didTapMenuButton), for: .touchUpInside)
    }
    
    private func addSubviews() {
        addSubview(headerView)
        addSubview(scrollView)
        scrollView.addSubview(contentScrollView)
        contentScrollView.addSubview(entranceLabel1)
        contentScrollView.addSubview(entranceLabel2)
        contentScrollView.addSubview(entranceLabel3)
        contentScrollView.addSubview(entranceLabel4)
        contentScrollView.addSubview(line1)
        contentScrollView.addSubview(entranceLabel5)
        contentScrollView.addSubview(entranceLabel6)
        contentScrollView.addSubview(entranceLabel7)
        contentScrollView.addSubview(entranceLabel8)
        contentScrollView.addSubview(entranceLabel9)
        contentScrollView.addSubview(line2)
        contentScrollView.addSubview(entranceLabel10)
    }
    
    /// Устанавливаем констрейнты
    private func makeConstraints() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(0)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(120)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).inset(0)
            $0.leading.trailing.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalTo(safeAreaLayoutGuide)
            //$0.height.equalTo(10000)
        }
        
        contentScrollView.snp.makeConstraints {
            //$0.centerX.equalTo(scrollView.snp.centerX)
            $0.bottom.equalTo(scrollView.snp.bottom).inset(50)
            $0.top.equalTo(scrollView.snp.top)
            $0.leading.equalTo(scrollView.snp.leading)
            $0.trailing.equalTo(scrollView.snp.trailing)
            $0.width.equalTo(scrollView.snp.width)
            $0.height.equalTo(800)
            
        }
        
        entranceLabel1.snp.makeConstraints {
            $0.top.equalTo(contentScrollView.snp.top).inset(15)
            $0.leading.equalTo(contentScrollView.snp.leading).inset(15)
            $0.trailing.equalTo(contentScrollView.snp.trailing).inset(15)
        }
        
        entranceLabel2.snp.makeConstraints {
            $0.top.equalTo(entranceLabel1.snp.bottom).inset(-10)
            $0.leading.equalTo(contentScrollView.snp.leading).inset(15)
            $0.trailing.equalTo(contentScrollView.snp.trailing).inset(15)
        }
        
        entranceLabel3.snp.makeConstraints {
            $0.top.equalTo(entranceLabel2.snp.bottom).inset(-10)
            $0.leading.equalTo(contentScrollView.snp.leading).inset(15)
            $0.trailing.equalTo(contentScrollView.snp.trailing).inset(15)
        }
        
        entranceLabel4.snp.makeConstraints {
            $0.top.equalTo(entranceLabel3.snp.bottom).inset(-10)
            $0.leading.equalTo(contentScrollView.snp.leading).inset(15)
            $0.trailing.equalTo(contentScrollView.snp.trailing).inset(15)
        }
        
        line1.snp.makeConstraints {
            $0.top.equalTo(entranceLabel4.snp.bottom).inset(-10)
            $0.leading.equalTo(contentScrollView.snp.leading)
            $0.trailing.equalTo(contentScrollView.snp.trailing)
            $0.height.equalTo(3)
        }
        
        entranceLabel5.snp.makeConstraints {
            $0.top.equalTo(line1.snp.bottom).inset(-10)
            $0.leading.equalTo(contentScrollView.snp.leading).inset(15)
            $0.trailing.equalTo(contentScrollView.snp.trailing).inset(15)
        }
        
        entranceLabel6.snp.makeConstraints {
            $0.top.equalTo(entranceLabel5.snp.bottom).inset(-5)
            $0.leading.equalTo(contentScrollView.snp.leading).inset(15)
            $0.trailing.equalTo(contentScrollView.snp.trailing).inset(15)
        }
        
        entranceLabel7.snp.makeConstraints {
            $0.top.equalTo(entranceLabel6.snp.bottom).inset(-5)
            $0.leading.equalTo(contentScrollView.snp.leading).inset(15)
            $0.trailing.equalTo(contentScrollView.snp.trailing).inset(15)
        }
        
        entranceLabel8.snp.makeConstraints {
            $0.top.equalTo(entranceLabel7.snp.bottom).inset(-5)
            $0.leading.equalTo(contentScrollView.snp.leading).inset(15)
            $0.trailing.equalTo(contentScrollView.snp.trailing).inset(15)
        }
        
        entranceLabel9.snp.makeConstraints {
            $0.top.equalTo(entranceLabel8.snp.bottom).inset(-5)
            $0.leading.equalTo(contentScrollView.snp.leading).inset(15)
            $0.trailing.equalTo(contentScrollView.snp.trailing).inset(15)
        }
        
        line2.snp.makeConstraints {
            $0.top.equalTo(entranceLabel9.snp.bottom).inset(-10)
            $0.leading.equalTo(contentScrollView.snp.leading)
            $0.trailing.equalTo(contentScrollView.snp.trailing)
            $0.height.equalTo(3)
        }
        
        entranceLabel10.snp.makeConstraints {
            $0.top.equalTo(line2.snp.bottom).inset(-10)
            $0.leading.equalTo(contentScrollView.snp.leading).inset(15)
            $0.trailing.equalTo(contentScrollView.snp.trailing).inset(15)
        }
        
    }
    
    @objc func didTapMenuButton() {
        delegate?.didTapMenuButton()
    }
}
