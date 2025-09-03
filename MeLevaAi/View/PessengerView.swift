//
//  PessengerView.swift
//  MeLevaAi
//
//  Created by Jean Ramalho on 27/04/25.
//  Corrigido por ChatGPT: estrutura de stacks, constraints e borda superior
//
import UIKit
import MapKit

final class PessengerView: UIView {
    
    // MARK: - Subviews
    
    lazy var destinyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        // branco semi-transparente
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    lazy var destinyMainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    // linha do "Meu Local" (círculo + label/textfield não editável)
    lazy var currentLocationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center     // alinha verticalmente o círculo e o textField
        stackView.distribution = .fill
        return stackView
    }()
    
    // linha do "Destino" (círculo + textField editável)
    lazy var destinyLocationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    // TextField não editável (Meu Local)
    lazy var currentLocationTextField: PaddedTextField = {
        let textField = PaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = "Meu Local"
        textField.isEnabled = false
        textField.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = Colors.darkSecondary.cgColor
        textField.layer.cornerRadius = 6
        textField.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textField
    }()
    
    // Círculo pequeno indicando origem
    lazy var currentLocationCircleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        // cornerRadius será ajustado no layoutSubviews para garantir metade da largura
        return view
    }()
    
    // Círculo pequeno indicando destino
    lazy var destinyLocationCircleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGreen
        return view
    }()
    
    // TextField editável (Destino)
    lazy var destinyLocationTextField: PaddedTextField = {
        let textField = PaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Digite seu destino..."
        textField.isEnabled = true                 // EDITÁVEL
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = Colors.darkSecondary.cgColor
        textField.layer.cornerRadius = 6
        textField.backgroundColor = .white
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textField
    }()
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    lazy var callCarButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Pedir Carona", for: .normal)
        button.backgroundColor = Colors.darkSecondary
        button.setTitleColor(Colors.defaultYellow, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 12
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Layout
    
    private func setupUI() {
        backgroundColor = .white
        // add subviews na ordem correta
        addSubview(mapView)
        addSubview(destinyView)
        addSubview(callCarButton)
        
        // Hierarquia dentro da detinyView
        destinyView.addSubview(destinyMainStackView)
        destinyMainStackView.addArrangedSubview(currentLocationStackView)
        destinyMainStackView.addArrangedSubview(destinyLocationStackView)
        
        // Linha do local atual
        currentLocationStackView.addArrangedSubview(currentLocationCircleView)
        currentLocationStackView.addArrangedSubview(currentLocationTextField)
        
        // Linha do destino
        destinyLocationStackView.addArrangedSubview(destinyLocationCircleView)
        destinyLocationStackView.addArrangedSubview(destinyLocationTextField)
        
        setConstraints()
        
        // adiciona borda superior fina para destacar a destinyView
        addTopBorder(to: destinyView, color: UIColor.systemGray3.cgColor, height: 0.5)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // garante o cornerRadius correto para os círculos (metade da largura)
        currentLocationCircleView.layer.cornerRadius = currentLocationCircleView.bounds.height / 2
        destinyLocationCircleView.layer.cornerRadius = destinyLocationCircleView.bounds.height / 2
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            // mapa ocupa todo o fundo
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // destinyView no topo, com margens e altura relativa (ajustável)
            destinyView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            destinyView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            destinyView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            destinyView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.15),
            
            // stack view preenche a destinyView com margins (já configuradas)
            destinyMainStackView.topAnchor.constraint(equalTo: destinyView.topAnchor),
            destinyMainStackView.leadingAnchor.constraint(equalTo: destinyView.leadingAnchor),
            destinyMainStackView.trailingAnchor.constraint(equalTo: destinyView.trailingAnchor),
            destinyMainStackView.bottomAnchor.constraint(equalTo: destinyView.bottomAnchor),
            
            // circle sizes (height + width) => tamanho pequeno e fixo
            currentLocationCircleView.heightAnchor.constraint(equalToConstant: 16),
            currentLocationCircleView.widthAnchor.constraint(equalToConstant: 16),
            destinyLocationCircleView.heightAnchor.constraint(equalToConstant: 16),
            destinyLocationCircleView.widthAnchor.constraint(equalToConstant: 16),
            
            // textfields height
            currentLocationTextField.heightAnchor.constraint(equalToConstant: 36),
            destinyLocationTextField.heightAnchor.constraint(equalToConstant: 36),
            
            // botão inferior
            callCarButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 18),
            callCarButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18),
            callCarButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            callCarButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    // MARK: - Helpers
    
    /// Adiciona uma borda superior (CALayer) à view indicada
    private func addTopBorder(to view: UIView, color: CGColor, height: CGFloat) {
        // remove border antiga (se houver)
        view.layer.sublayers?
            .filter { $0.name == "topBorder" }
            .forEach { $0.removeFromSuperlayer() }
        
        let border = CALayer()
        border.name = "topBorder"
        border.backgroundColor = color
        border.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: height)
        border.contentsScale = UIScreen.main.scale
        view.layer.addSublayer(border)
        
        // Ajusta largura quando a view for redimensionada
        // (obs: será reposicionado em layoutSubviews se necessário)
        DispatchQueue.main.async {
            border.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: height)
        }
    }
}
