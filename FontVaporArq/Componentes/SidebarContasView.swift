//
//  SidebarContasView.swift
//  FontVaporArq
//
//  Created by Éverton Alencar de Lima on 02/06/26.
//

import SwiftUI

struct SidebarContasView: View {
    @EnvironmentObject private var store: ContaStore
    @State private var mostrarCadastro = false

    private var selecaoBinding: Binding<UUID?> {
        Binding(
            get: { store.contaSelecionadaId },
            set: { newValue in
                // Defer publishing changes to avoid "Publishing changes from within view updates" warning
                DispatchQueue.main.async {
                    store.contaSelecionadaId = newValue
                }
            }
        )
    }

    var body: some View {
        List(store.contas, id: \.id, selection: selecaoBinding) { conta in
            SidebarContaItemView(conta: conta)
                .tag(conta.id)
        }
        .navigationTitle("Contas")
        .listStyle(.sidebar)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    mostrarCadastro = true
                } label: {
                    Image(systemName: "plus")
                        .fontWeight(.semibold)
                }
                .help("Nova conta")
            }
        }
        .sheet(isPresented: $mostrarCadastro) {
            CadastroContaView(aoFinalizar: { mostrarCadastro = false })
                .environmentObject(store)
        }
    }
}
