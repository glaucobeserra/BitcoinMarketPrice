//
//  Result.swift
//  net
//
//  Created by Glauco Dantas Beserra on 28/06/19.
//  Copyright © 2019 Glauco Dantas Beserra. All rights reserved.
//

import Foundation

enum Result<T, U> where U: Error  {
    case success(T)
    case failure(U)
}
