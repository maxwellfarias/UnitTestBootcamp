//
//  UnitTestBootcampView.swift
//  UnitTestBootcamp
//
//  Created by Maxwell Santos Farias on 10/01/24.
//

import SwiftUI

struct UnitTestBootcampView: View {
    @StateObject var viewModel: UnitTestBootcampViewModel
    
    init(isPremium: Bool) {
        _viewModel = StateObject(wrappedValue: UnitTestBootcampViewModel(isPremium: isPremium))
    }
    var body: some View {
        Text(viewModel.isPremium.description)
            
    }
}

#Preview {
    UnitTestBootcampView(isPremium: true)
}
