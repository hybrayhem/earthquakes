//
//  Quakes.swift
//  Earthquakes
//
//  The views of the app, which display details of the fetched earthquake data.
//

import SwiftUI

struct Quakes: View {
    @AppStorage("lastUpdated")
    var lastUpdated = Date.distantFuture.timeIntervalSince1970
    
    @EnvironmentObject var provider: QuakesProvider
    @State var editMode: EditMode = .inactive
    @State var selectMode: SelectMode = .inactive
    @State var isLoading = false
    @State var selection: Set<String> = []
    @State private var error: QuakeError?
    @State private var hasError = false
    
    var body: some View {
        NavigationView {
            applyQuakeListModifiers(to: quakeList)
        }
        .task {
            await fetchQuakes()
        }
    }
    
    @ViewBuilder
    var quakeRows: some View {
        ForEach(provider.quakes) { quake in
            NavigationLink(destination: QuakeDetail(quake: quake)) {
                QuakeRow(quake: quake)
            }
        }
        .onDelete(perform: deleteQuakes)
    }
    
    @ViewBuilder
    var quakeList: some View {
        // To fix selection glitch
//        if editMode == .inactive {
//            List {
//                quakeRows
//            }
//        } else {
            List(selection: $selection) {
                quakeRows
            }
//        }
    }
    
    func applyQuakeListModifiers<V: View>(to view: V) -> some View {
        view
            .listStyle(.inset)
            .navigationTitle(title)
            .toolbar(content: toolbarContent)
            .environment(\.editMode, $editMode)
            .refreshable {
                await fetchQuakes()
            }
            .alert(isPresented: $hasError, error: error) {}
    }
}

extension Quakes {
    var title: String {
        if !editMode.isEditing || selectMode.isActive || selection.isEmpty {
            return "Earthquakes"
        } else {
            return "\(selection.count) Selected"
        }
    }
    
    func deleteQuakes(at offsets: IndexSet) {
        provider.deleteQuakes(atOffsets: offsets)
    }
    func deleteQuakes(for codes: Set<String>) {
        var offsetsToDelete: IndexSet = []
        for (index, element) in provider.quakes.enumerated() {
            if codes.contains(element.code) {
                offsetsToDelete.insert(index)
            }
        }
        deleteQuakes(at: offsetsToDelete)
        selection.removeAll()
    }
    func fetchQuakes() async {
        isLoading = true
        do {
            try await provider.fetchQuakes()
            lastUpdated = Date().timeIntervalSince1970
        } catch {
            self.error = error as? QuakeError ?? .unexpectedError(error: error)
            self.hasError = true
        }
        isLoading = false
    }
}

#Preview {
    Quakes()
        .environmentObject(
            QuakesProvider(
                client: QuakeClient(downloader: TestDownloader())
            )
        )
}
