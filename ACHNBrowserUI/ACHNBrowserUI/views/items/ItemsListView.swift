//
//  ContentView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct ItemsListView: View {
    @ObservedObject private var viewModel = ItemsViewModel(categorie: .housewares)
    @State private var showFilterSheet = false
    
    let categories: [Categories]
    
    private var filterButton: some View {
        Button(action: {
            self.showFilterSheet.toggle()
        }) {
            Image(systemName: "line.horizontal.3.decrease.circle")
                .font(.title)
        }
    }
    
    private var filterSheet: ActionSheet {
        var buttons: [ActionSheet.Button] = []
        for filter in categories {
            buttons.append(.default(Text(filter.rawValue.capitalized),
                                    action: {
                                        self.viewModel.categorie = filter
            }))
        }
        buttons.append(.cancel())
        return ActionSheet(title: Text("Filter items"), buttons: buttons)
    }
    
    var body: some View {
        NavigationView {
            List {
                SearchField(searchText: $viewModel.searchText).listRowBackground(Color.grass)
                ForEach(!viewModel.searchText.isEmpty ? viewModel.searchItems : viewModel.items) { item in
                    NavigationLink(destination: ItemDetailView(item: item,
                                                               viewModel: self.viewModel)) {
                        ItemRowView(item: item)
                            .listRowBackground(Color.dialogue)
                    }
                }
            }
            .background(Color.dialogue)
            .navigationBarItems(trailing: filterButton
                .sheet(isPresented: $showFilterSheet, content: { CategoriesView(categories: self.categories,
                                                                                selectedCategory: self.$viewModel.categorie) }))
            .navigationBarTitle(Text(viewModel.categorie.rawValue.capitalized),
                                displayMode: .inline)
        }.onAppear {
            self.viewModel.categorie = self.categories.first!
        }
    }
}

struct ItemsListViewPreviews: PreviewProvider {
    static var previews: some View {
        ItemsListView(categories: Categories.items())
            .environmentObject(Collection())
    }
}