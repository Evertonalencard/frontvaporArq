//
//  ContentView.swift
//  FontVaporArq
//
//  Created by Éverton Alencar de Lima on 02/06/26.
//

import SwiftUI
import SwiftData

// MARK: - Modelo de Feedback

struct FeedbackBancario: Identifiable {
    let id   = UUID()
    let mensagem: String
    let sucesso: Bool
}

struct ContentView: View {
    @EnvironmentObject private var store: ContaStore

    var body: some View {
        NavigationSplitView {
            SidebarContasView()
                .navigationSplitViewColumnWidth(min: 220, ideal: 250, max: 300)
        } detail: {
            if let conta = store.contaSelecionada {
                DashboardContaView(conta: conta)
            } else {
                VStack(spacing: 12) {
                    Image(systemName: "arrow.left")
                        .font(.largeTitle)
                        .foregroundStyle(.white.opacity(0.3))
                    Text("Selecione ou cadastre uma conta")
                        .foregroundStyle(.white.opacity(0.5))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(BackgorundFile())
            }
        }
        .frame(minWidth: 860, minHeight: 580)
        .task {
            await store.carregarContas()
        }
    }
}



// MARK: - Utilitário global de formatação

func formatarMoeda(_ valor: Double) -> String {
    let f = NumberFormatter()
    f.numberStyle = .currency
    f.locale = Locale(identifier: "pt_BR")
    // Use NSNumber for proper bridging
    if let formatted = f.string(from: NSNumber(value: valor)) {
        return formatted
    }
    // Fallback formatting in case the formatter fails for some reason
    let symbol = f.currencySymbol ?? "R$"
    f.minimumFractionDigits = 2
    f.maximumFractionDigits = 2
    let numberString = f.string(from: NSNumber(value: (valor as Double))) ?? String(format: "%.2f", valor)
    return "\(symbol) \(numberString.replacingOccurrences(of: symbol, with: "").trimmingCharacters(in: .whitespaces))"
}

// MARK: - Preview

#Preview {
    ContentView()
        .environmentObject(ContaStore())
        .modelContainer(for: Item.self, inMemory: true)
}

