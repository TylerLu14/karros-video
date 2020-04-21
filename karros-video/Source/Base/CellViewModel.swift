//
//  CellViewModel.swift
//  cinemaxxi
//
//  Created by Hoang Lu on 10/31/19.
//  Copyright © 2019 Lu. All rights reserved.
//

import Foundation

class CellViewModel: BaseViewModel, GenericCellViewModel {
	
	private let uuid = UUID()
	
    var identity: String {
		return uuid.uuidString
    }
}
