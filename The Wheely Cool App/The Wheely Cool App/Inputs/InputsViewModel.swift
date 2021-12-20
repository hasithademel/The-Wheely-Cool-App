//
//  InputsViewModel.swift
//  The Wheely Cool App
//
//  Created by Hasitha De Mel on 20/12/21.
//

import Foundation

class InputsViewModel: BaseViewModel {
    
    @Published private(set) var options: [String] = []
    
    private func loadOptions() -> [String] {
         let savedOptions = UserDefaults.standard.object(forKey: "options") as? [String] ?? []
         return savedOptions
     }
    
    private func sync(options: [String]) {
        UserDefaults.standard.setValue(options, forKey: "options")
        self.loadData()
    }
    
    func loadData() {
        self.options = loadOptions()
    }
    

    func addOption(option: String) {
        var savedOptions = self.loadOptions()
        savedOptions.append(option)
        sync(options: savedOptions)
    }
    
    func deleteOptionAt(index: Int) {
        var savedOptions = self.loadOptions()
        savedOptions.remove(at: index)
        sync(options: savedOptions)
    }
    
    func numberOfOptions() -> Int {
        return options.count
    }
    
    func optionAt(row: Int) -> String {
        return options[row]
    }
}
