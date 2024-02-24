//
//  EditButton.swift
//  Earthquakes
//
//  The edit button of the app.
//

import SwiftUI

struct EditButton: View {
    @Binding var editMode: EditMode
    var action: () -> Void = {}
    var body: some View {
        Button {
            withAnimation {
                if editMode == .active {
                    action()
                    editMode = .inactive
                } else {
                    editMode = .active
                }
            }
        } label: {
            if editMode == .active {
                Text("Cancel").bold()
            } else {
                Text("Edit")
            }
        }
    }
}

@available(iOS 17.0, *)
#Preview(traits: .sizeThatFitsLayout) {
    Group {
        EditButton(editMode: .constant(.inactive))
        EditButton(editMode: .constant(.active))
        EditButton(editMode: .constant(.transient))
    }
}
