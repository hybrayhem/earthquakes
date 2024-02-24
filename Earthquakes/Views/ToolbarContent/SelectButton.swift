//
//  SelectButton.swift
//  Earthquakes
//
//  The select button of the app which toggles between selection and deselection.
//

import SwiftUI

enum SelectMode {
    case active, inactive
    
    var isActive: Bool {
        self == .active
    }
    
    mutating func toggle() {
        switch self {
        case .active:
            self = .inactive
        case .inactive:
            self = .active
        }
    }
}

struct SelectButton: View {
    @Binding var mode: SelectMode
    var action: () -> Void = {}
    var body: some View {
        Button {
            withAnimation {
                mode.toggle()
                action()
            }
        } label: {
            Text(mode.isActive ? "Deselect All" : "Select All")
        }
    }
}

@available(iOS 17.0, *)
#Preview(traits: .sizeThatFitsLayout) {
    Group {
        SelectButton(mode: .constant(.active))
        SelectButton(mode: .constant(.inactive))
    }
}
