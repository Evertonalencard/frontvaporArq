//
//  FolhaAcaoView.swift
//  FontVaporArq
//
//  Created by Éverton Alencar de Lima on 02/06/26.
//

import SwiftUI


// MARK: - Folha de Ação (Sheet)

struct FolhaAcaoView: View {
    let acao:           AcaoBancaria
    @ObservedObject var conta: ContaRegistrada
    let contasDestino:  [ContaRegistrada]
    let aoFinalizar:    (Resultado) -> Void
    let aoFechar:       () -> Void
    
    @State private var valorTexto:    String = ""
    @State private var contaDestinoId: UUID?  = nil
    @State private var erroLocal:     String = ""
    
    private var contaDestino: ContaRegistrada? {
        contasDestino.first { $0.id == contaDestinoId }
    }
    
    var body: some View {
        ZStack {
            
            
            VStack(spacing: 0) {
                cabecalho
                Divider().background(.branco.opacity(0.15))
                conteudo
                    .padding(24)
                Spacer()
            }
        }
        .frame(width: 420, height: 440)
    }
    
    // MARK: Cabeçalho
    
    private var cabecalho: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(acao.corIcone.opacity(0.2))
                    .frame(width: 60, height: 60)
                Image(systemName: acao.icone)
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundStyle(acao.corIcone)
            }
            Text(acao.rawValue)
                .font(.title2.weight(.bold))
                .foregroundStyle(.branco)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 24)
    }
    
    // MARK: Conteúdo
    
    @ViewBuilder
    private var conteudo: some View {
        ScrollView{
            VStack(spacing: 16) {
                if acao == .dadosCadastrais {
                    dadosCadastraisView
                } else {
                    if acao.precisaDestino { pickerDestino }
                    if acao.precisaValor   { campoValor    }
                    if !erroLocal.isEmpty  { erroView      }
                    botaoConfirmar
                }
            }
        }
    }
    
    // MARK: Picker de destino
    
    private var pickerDestino: some View {
        VStack(alignment: .leading, spacing: 8) {
            rotulo("CONTA DE DESTINO")
            if contasDestino.isEmpty {
                HStack(spacing: 6) {
                    Image(systemName: "info.circle")
                        .foregroundStyle(.yellow)
                    Text("Nenhuma conta de destino disponível. Cadastre outra conta corrente ou internacional.")
                        .font(.caption)
                        .foregroundStyle(.branco.opacity(0.7))
                }
                .padding(12)
                .background(.branco.opacity(0.08), in: RoundedRectangle(cornerRadius: 10))
            } else {
                
                VStack(spacing: 6) {
                    ForEach(contasDestino) { destino in
                        Button {
                            withAnimation(.spring(response: 0.2)) {
                                contaDestinoId = destino.id
                            }
                        } label: {
                            HStack(spacing: 10) {
                                ZStack {
                                    Circle()
                                        .fill(destino.tipo.cor.opacity(0.2))
                                        .frame(width: 32, height: 32)
                                    Image(systemName: destino.tipo.icone)
                                        .font(.system(size: 13, weight: .semibold))
                                        .foregroundStyle(destino.tipo.cor)
                                }
                                VStack(alignment: .leading, spacing: 1) {
                                    Text(destino.nome)
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(.branco)
                                    Text(destino.tipo.rawValue)
                                        .font(.caption)
                                        .foregroundStyle(.branco.opacity(0.5))
                                }
                                Spacer()
                                Image(systemName: contaDestinoId == destino.id
                                      ? "checkmark.circle.fill" : "circle")
                                .foregroundStyle(contaDestinoId == destino.id
                                                 ? destino.tipo.cor : .branco.opacity(0.3))
                                .font(.body)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(contaDestinoId == destino.id
                                          ? .branco.opacity(0.12) : .branco.opacity(0.06))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(contaDestinoId == destino.id
                                            ? destino.tipo.cor.opacity(0.4) : Color.clear, lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
    
    // MARK: Campo de valor
    
    private var campoValor: some View {
        VStack(alignment: .leading, spacing: 6) {
            rotulo("VALOR (R$)")
            TextField("0,00", text: $valorTexto)
                .textFieldStyle(.plain)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .padding(14)
                .background(.branco.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
                .foregroundStyle(.branco)
                .tint(.branco)
        }
    }
    
    // MARK: Erro
    
    private var erroView: some View {
        HStack(spacing: 6) {
            Image(systemName: "exclamationmark.circle.fill").foregroundStyle(.red)
            Text(erroLocal).font(.subheadline).foregroundStyle(.red.opacity(0.9))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .transition(.move(edge: .top).combined(with: .opacity))
    }
    
    // MARK: Botão confirmar
    
    private var botaoConfirmar: some View {
        Button(action: executar) {
            Text("Confirmar")
                .font(.headline)
                .foregroundStyle(.branco)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(.branco.opacity(0.18), in: RoundedRectangle(cornerRadius: 14))
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(.branco.opacity(0.1), lineWidth: 1))
        }
        .buttonStyle(.plain)
        .padding(.top, 4)
    }
    
    // MARK: Dados cadastrais
    
    private var dadosCadastraisView: some View {
        VStack(spacing: 16) {
            // dados vêm do modelo, sem controller
            let dados = """
            Nome: \(conta.nome)
            Tipo: \(conta.tipo.rawValue)
            Saldo: \(formatarMoeda(conta.saldo))
            ID: \(conta.id.uuidString)
            """
            
            Text(dados)
                .font(.body)
                .foregroundStyle(.branco.opacity(0.85))
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.branco.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
            
            Button(action: aoFechar) {
                Text("Fechar")
                    .font(.headline)
                    .foregroundStyle(.branco)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(.branco.opacity(0.15), in: RoundedRectangle(cornerRadius: 14))
            }
            .buttonStyle(.plain)
        }
    }
    
    // MARK: Executar operação via Controller
    
    private func executar() {
        withAnimation { erroLocal = "" }
        guard acao.precisaValor else { return }
        
        let valorNorm = valorTexto
            .replacingOccurrences(of: ",", with: ".")
            .trimmingCharacters(in: .whitespaces)
        
        guard let valor = Decimal(string: valorNorm), valor > 0 else {
            withAnimation { erroLocal = "Insira um valor válido maior que zero." }
            return
        }
        
        if acao.precisaDestino && contaDestinoId == nil {
            withAnimation { erroLocal = "Selecione uma conta de destino." }
            return
        }
        
        // ← chamada async para o backend
        Task {
            do {
                let dto = try await executarOperacaoRemota(valor: valor)
                let resultado = dto.toResultado()
                await MainActor.run {
                    switch resultado {
                    case .sucesso: aoFinalizar(resultado)
                    case .falha(let erro): withAnimation { erroLocal = erro }
                    }
                }
            } catch {
                await MainActor.run {
                    withAnimation { erroLocal = "Erro de conexão com o servidor." }
                }
            }
        }
    }
    
    private func executarOperacaoRemota(valor: Decimal) async throws -> ResultadoAPIDTO {
        let contaId = conta.id
        let api = BancoAPIClient.shared
        
        switch acao {
        case .depositar:
            return try await api.depositar(contaId: contaId, valor: valor)
        case .sacar:
            return try await api.sacar(contaId: contaId, valor: valor)
            //        case .pix:
            //            guard let destinoId = contaDestinoId else { throw URLError(.badURL) }
            //            return try await api.pix(origemId: contaId, destinoId: destinoId, valor: valor)
        case .pix, .transferencia, .pagEspecie, .salario:
            return ResultadoAPIDTO(
                sucesso: false,
                id: nil,
                novoValor: nil,
                erro: "Operação ainda não disponível no ambiente local."
            )
        case .transferencia:
            guard let destinoId = contaDestinoId else { throw URLError(.badURL) }
            return try await api.transferencia(origemId: contaId, destinoId: destinoId, valor: valor)
            
        case .dadosCadastrais:
            return ResultadoAPIDTO(
                sucesso: true,
                id: conta.id,
                novoValor: conta.saldo,
                erro: nil
            )
        default:
            throw URLError(.unsupportedURL)
        }
    }
    
    private func rotulo(_ texto: String) -> some View {
        Text(texto)
            .font(.system(size: 10, weight: .bold))
            .tracking(1.5)
            .foregroundStyle(.branco.opacity(0.5))
    }
}
