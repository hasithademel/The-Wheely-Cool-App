//
//  WheelViewModel.swift
//  The Wheely Cool App
//
//  Created by Hasitha De Mel on 20/12/21.
//

import Foundation

class WheelViewModel: BaseViewModel {
    
    var options: [String] = []

    init(options: [String]) {
        self.options = options
    }
    
    func optionAt(index: Int) -> String {
        return options[index]
    }
}
