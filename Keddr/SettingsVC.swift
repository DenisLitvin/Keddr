//
//  SettingsVC.swift
//  Keddr
//
//  Created by macbook on 03.10.2017.
//  Copyright © 2017 DenisLitvin. All rights reserved.
//

import UIKit

class SettingsVC: SlideOutTableViewController {
    
    var sections: [SettingsSection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupItemsAndSections()
    }
    func setupViews(){
        self.tableView.register(SliderSettingsCell.self, forCellReuseIdentifier: SettingsItemType.slider.rawValue)
        self.tableView.register(BaseSettingsCell.self, forCellReuseIdentifier: SettingsItemType.text.rawValue)
    }
    func setupItemsAndSections(){
        let firstSection = SettingsSection(title: "Размер Шрифта", items: [SettingsItem(type: .slider)])
        let secondSection = SettingsSection(title: "Прочее", items: [SettingsItem(type: .text, content: "О Проекте")])
        sections = [firstSection, secondSection]
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].items[indexPath.item]
        let cell = tableView.dequeueReusableCell(withIdentifier: item.type.rawValue, for: indexPath) as! BaseSettingsCell
        cell.content = item.content
        return cell
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height: CGFloat
        if sections[indexPath.section].items[indexPath.item].type == .slider {
            height = 80
        } else {
            height = 40
        }
        return height
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = sections[indexPath.section].items[indexPath.item]
        if item.content == "О Проекте"{
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "AboutVC")
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return 
    }

}















