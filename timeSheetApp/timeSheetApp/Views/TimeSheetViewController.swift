//
//  TimeSheetViewController.swift
//  timeSheetApp
//
//  Created by Петр Тартынских on 02.04.2020.
//  Copyright © 2020 Петр Тартынских. All rights reserved.
//

import UIKit
import SnapKit

class TimeSheetViewController: UIViewController {
    
    // Private
    private let barcodeData: String
    
    // UI
    private var barcodeDataLabel: UILabel!
    
    // Services
    private var networkService: NetworkService = NetworkServiceImplementation.shared
    
    // Public
    init(barcodeData: String) {
        self.barcodeData = barcodeData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        networkService.delegate = self
        printTabel()
    }
}

// MARK: - Private
private extension TimeSheetViewController {
    
    private func printTabel() {
        guard let tabelNum = Int(barcodeData) else { return }
        LoadingIndicatorView.show()
        networkService.printTabel(tabelNum: tabelNum)
    }
    
    private func onSuccsessPrint() {
        let alertController = UIAlertController(title: "Успех", message: "Табель успешно зафиксирован", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ок", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func onFailedPrint() {
        let alertController = UIAlertController(title: "Ошибка", message: "Не удалось зафиксировать табель", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ок", style: .default))
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UI
private extension TimeSheetViewController {
    
    private func setupView() {
        // self
        view.backgroundColor = Design.Colors.blueColor
        
        // barcodeDataLabel
        barcodeDataLabel = UILabel()
        barcodeDataLabel.font = Design.Fonts.BigHeader.font
        barcodeDataLabel.textColor = Design.Fonts.BigHeader.color
        barcodeDataLabel.textAlignment = .center
        barcodeDataLabel.text = barcodeData
        view.addSubview(barcodeDataLabel)
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        // barcodeDataLabel
        barcodeDataLabel.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - NetworkServiceDelegate
extension TimeSheetViewController: NetworkServiceDelegate {
    
    func networkServiceDidPrintTabel(_ networkService: NetworkService) {
        DispatchQueue.main.async { [unowned self] in
            LoadingIndicatorView.hide()
            self.onSuccsessPrint()
        }
    }
    
    func networkService(_ networkService: NetworkService, failedWith error: NetworkServiceError) {
        DispatchQueue.main.async { [unowned self] in
            LoadingIndicatorView.hide()
            self.onFailedPrint()
        }
    }
}
