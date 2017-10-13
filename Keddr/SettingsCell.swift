//
//  SettingsCell.swift
//  Keddr
//
//  Created by macbook on 03.10.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class BaseSettingsCell: UITableViewCell {
    
    weak var delegate: SettingsVC?

    var content: String? {
        didSet{
            setupContent()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Font.description.create()
        label.textColor = Color.darkGray
        return label
    }()
    
    func setupViews(){
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 10, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 0)
    }
    func setupContent(){
        guard let content = content else { return }
        titleLabel.text = content
    }
}

class SliderSettingsCell: BaseSettingsCell{
    
    lazy var sliderView: UISlider = { [unowned self] in
        let slider = UISlider()
        slider.minimumValue = -0.3
        slider.maximumValue = 0.8
        slider.value = UserDefaults.standard.getUserTextSizeMultiplier()
        slider.thumbTintColor = Color.darkGray
        slider.minimumTrackTintColor = Color.keddrYellow
        slider.addTarget(self, action: #selector(handleSliderValueDidChange), for: .touchDragInside)
        return slider
    }()
    let leftChar: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 15)
        view.text = "A"
        return view
    }()
    let rightChar: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 30)
        view.text = "A"
        return view
    }()
    let warningLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Font.date.create()
        label.textColor = Color.darkGray
        label.text = "Необходимо перезагрузить приложение!"
        return label
    }()
    override func setupViews() {
        //setup self
        selectionStyle = .none
        //setup views
        addSubview(sliderView)
        addSubview(leftChar)
        addSubview(rightChar)
        addSubview(warningLabel)
        
        sliderView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 30, bottomConstant: 15, rightConstant: 30, widthConstant: 0, heightConstant: 30)
        leftChar.anchor(top: nil, left: sliderView.leftAnchor, bottom: sliderView.topAnchor, right: nil, topConstant: 0, leftConstant: 10, bottomConstant: 5, rightConstant: 0, widthConstant: 20, heightConstant: 15)
        rightChar.anchor(top: nil, left: nil, bottom: sliderView.topAnchor, right: sliderView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 5, rightConstant: 10, widthConstant: 20, heightConstant: 21)
        warningLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 80, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    @objc func handleSliderValueDidChange(_ slider: UISlider){
        UserDefaults.standard.setUserTextSizeMultiplier(size: slider.value)
        delegate?.shouldExpandSliderCell = true
    }
}

class SwitcherSettingsCell: BaseSettingsCell{
    
    lazy var switcherButton: UISwitch = { [unowned self] in
        let switcher = UISwitch()
        switcher.isOn = UserDefaults.standard.isSimplifiedLayout()
        switcher.addTarget(self, action: #selector(switcherButtonTapped), for: .touchUpInside)
        return switcher
    }()
    
    override func setupViews() {
        super.setupViews()
        //setup self
        selectionStyle = .none
        //setup views
        addSubview(switcherButton)
        
        switcherButton.anchor(top: centerYAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: -switcherButton.frame.height / 2, leftConstant: 0, bottomConstant: 0, rightConstant: 10, widthConstant: 0, heightConstant: 0)
    }
    @objc func switcherButtonTapped(){
        delegate?.handleSwitcherButton(for: self, isOn: switcherButton.isOn)
    }
}














