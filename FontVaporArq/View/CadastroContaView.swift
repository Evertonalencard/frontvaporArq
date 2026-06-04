//
//  CadastroContaView.swift
//  FontVaporArq
//
//  Created by Éverton Alencar de Lima on 02/06/26.
//

import SwiftUI

struct CadastroContaView: View {
    @EnvironmentObject private var store: ContaStore
    let aoFinalizar: () -> Void

    @State private var nome:             String   = ""
    @State private var tipoSelecionado:  TipoConta = .corrente
    @State private var erro:             String   = ""

    var body: some View {
        ZStack {
            BackgorundFile()

            VStack(spacing: 0) {
                cabecalho
                Divider().background(.branco.opacity(0.15))
                formulario
                    .padding(24)
                Spacer()
            }
        }
        .frame(width: 400, height: 500)
    }

    // MARK: - Cabeçalho

    private var cabecalho: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(.cyan.opacity(0.2))
                    .frame(width: 60, height: 60)
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(.cyan)
            }
            Text("Nova Conta")
                .font(.title2.weight(.bold))
                .foregroundStyle(.branco)
            Text("Preencha os dados para abrir sua conta")
                .font(.subheadline)
                .foregroundStyle(.branco.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
    }

    // MARK: - Formulário

    private var formulario: some View {
        VStack(spacing: 18) {

            // Campo nome
            VStack(alignment: .leading, spacing: 6) {
                rotulo("NOME DO TITULAR")
                TextField("Ex: João Silva", text: $nome)
                    .textFieldStyle(.plain)
                    .padding(12)
                    .background(.branco.opacity(0.1), in: RoundedRectangle(cornerRadius: 10))
                    .foregroundStyle(.branco)
                    .tint(.branco)
            }

            // Seletor de tipo
            VStack(alignment: .leading, spacing: 8) {
                rotulo("TIPO DE CONTA")
                VStack(spacing: 8) {
                    ForEach(TipoConta.allCases) { tipo in
                        TipoContaRowView(
                            tipo: tipo,
                            selecionado: tipoSelecionado == tipo
                        ) { tipoSelecionado = tipo }
                    }
                }
            }

            // Erro
            if !erro.isEmpty {
                HStack(spacing: 6) {
                    Image(systemName: "exclamationmark.circle.fill").foregroundStyle(.red)
                    Text(erro).font(.subheadline).foregroundStyle(.red.opacity(0.9))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .transition(.move(edge: .top).combined(with: .opacity))
            }

            // Botões
            HStack(spacing: 12) {
                Button("Cancelar") { aoFinalizar() }
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                    .background(.branco.opacity(0.08), in: RoundedRectangle(cornerRadius: 12))
                    .foregroundStyle(.branco.opacity(0.7))

                Button("Cadastrar") { cadastrar() }
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                    .background(.cyan.opacity(0.25), in: RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(.cyan.opacity(0.4), lineWidth: 1))
                    .foregroundStyle(.branco)
                    .fontWeight(.semibold)
            }
            .padding(.top, 4)
        }
    }

    // MARK: - Helpers

    private func rotulo(_ texto: String) -> some View {
        Text(texto)
            .font(.system(size: 10, weight: .bold))
            .tracking(1.5)
            .foregroundStyle(.branco.opacity(0.5))
    }

    private func cadastrar() {
        let nomeLimpo = nome.trimmingCharacters(in: .whitespaces)
        guard !nomeLimpo.isEmpty else {
            withAnimation { erro = "O nome do titular é obrigatório." }
            return
        }
        store.adicionar(nome: nomeLimpo, tipo: tipoSelecionado)
        aoFinalizar()
    }
}

// MARK: - Row de tipo de conta

struct TipoContaRowView: View {
    let tipo: TipoConta
    let selecionado: Bool
    let aoTocar: () -> Void

    var body: some View {
        Button(action: aoTocar) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(tipo.cor.opacity(0.2))
                        .frame(width: 38, height: 38)
                    Image(systemName: tipo.icone)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(tipo.cor)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(tipo.titulo)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.branco)
                    Text(tipo.descricao)
                        .font(.caption)
                        .foregroundStyle(.branco.opacity(0.5))
                }

                Spacer()

                Image(systemName: selecionado ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(selecionado ? tipo.cor : .branco.opacity(0.3))
                    .font(.title3)
                    .animation(.spring(response: 0.2), value: selecionado)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(selecionado ? .branco.opacity(0.12) : .branco.opacity(0.05))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(selecionado ? tipo.cor.opacity(0.45) : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.25), value: selecionado)
    }
}

#Preview {
    CadastroContaView(aoFinalizar: {})
        .environmentObject(ContaStore())
}
