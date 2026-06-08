import SwiftUI

struct FolhaAcaoView: View {
    let acao: AcaoBancaria
    @ObservedObject var conta: ContaRegistrada
    let contasDestino: [ContaRegistrada]
    let aoFinalizar: (Resultado) -> Void
    let aoFechar: () -> Void

    @State private var valorTexto = ""
    @State private var contaDestinoId: UUID? = nil
    @State private var erroLocal = ""
    @State private var carregandoDados = false

    private var contaDestino: ContaRegistrada? {
        contasDestino.first { $0.id == contaDestinoId }
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                cabecalho
                Divider().background(.branco.opacity(0.15))
                conteudo.padding(24)
            }
        }
        .frame(width: 420, height: 500)
        .task {
            if acao == .dadosCadastrais {
                await carregarDadosCadastrais()
            }
        }
    }

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

    @ViewBuilder
    private var conteudo: some View {
        ScrollView {
            VStack(spacing: 16) {
                if acao == .dadosCadastrais {
                    dadosCadastraisView
                } else {
                    if acao.precisaDestino {
                        pickerDestino
                    }

                    if acao.precisaValor {
                        campoValor
                    }

                    if !erroLocal.isEmpty {
                        erroView
                    }

                    botaoConfirmar
                }
            }
        }
    }

    private var pickerDestino: some View {
        VStack(alignment: .leading, spacing: 8) {
            rotulo("CONTA DE DESTINO")

            if contasDestino.isEmpty {
                HStack(spacing: 6) {
                    Image(systemName: "info.circle")
                        .foregroundStyle(.yellow)

                    Text("Nenhuma conta de destino disponível.")
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

                                    Text(destino.tipo.titulo)
                                        .font(.caption)
                                        .foregroundStyle(.branco.opacity(0.5))
                                }

                                Spacer()

                                Image(systemName: contaDestinoId == destino.id ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(contaDestinoId == destino.id ? destino.tipo.cor : .branco.opacity(0.3))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(contaDestinoId == destino.id ? .branco.opacity(0.12) : .branco.opacity(0.06))
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private var campoValor: some View {
        VStack(alignment: .leading, spacing: 6) {
            rotulo("VALOR")

            TextField("0,00", text: $valorTexto)
                .textFieldStyle(.plain)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .padding(14)
                .background(.branco.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
                .foregroundStyle(.branco)
                .tint(.branco)
        }
    }

    private var erroView: some View {
        HStack(spacing: 6) {
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundStyle(.red)

            Text(erroLocal)
                .font(.subheadline)
                .foregroundStyle(.red.opacity(0.9))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var botaoConfirmar: some View {
        Button(action: executar) {
            Text("Confirmar")
                .font(.headline)
                .foregroundStyle(.branco)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(.branco.opacity(0.18), in: RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(.branco.opacity(0.1), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
        .padding(.top, 4)
    }

    private var dadosCadastraisView: some View {
        VStack(spacing: 16) {
            Group {
                if carregandoDados {
                    ProgressView()
                        .tint(.white)
                } else {
                    let dados = """
                    Nome: \(conta.nome)
                    Tipo: \(conta.tipo.titulo)
                    Saldo: \(formatarMoeda(conta.saldo))
                    Salário: \(formatarMoeda(conta.salario))
                    Possui cartão: \(conta.possuiCartao ? "Sim" : "Não")
                    Limite do cartão: \(conta.limiteCartao != nil ? formatarMoeda(conta.limiteCartao!) : "Não possui")
                    Último empréstimo: \(conta.ultimoEmprestimo != nil ? formatarMoeda(conta.ultimoEmprestimo!) : "Nenhum")
                    ID: \(conta.id.uuidString)
                    """

                    Text(dados)
                        .font(.body)
                        .foregroundStyle(.branco.opacity(0.85))
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.branco.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
                }
            }

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

    private func executar() {
        withAnimation {
            erroLocal = ""
        }

        guard !acao.precisaValor || !valorTexto.trimmingCharacters(in: .whitespaces).isEmpty else {
            withAnimation {
                erroLocal = "Informe um valor."
            }
            return
        }

        let valorNorm = valorTexto
            .replacingOccurrences(of: ",", with: ".")
            .trimmingCharacters(in: .whitespaces)

        let valor = Double(valorNorm) ?? 0

        if acao.precisaValor && valor <= 0 {
            withAnimation {
                erroLocal = "Insira um valor válido maior que zero."
            }
            return
        }

        if acao.precisaDestino && contaDestinoId == nil {
            withAnimation {
                erroLocal = "Selecione uma conta de destino."
            }
            return
        }

        Task {
            do {
                let dto = try await executarOperacaoRemota(valor: valor)
                let resultado = dto.toResultado()

                await MainActor.run {
                    switch resultado {
                    case .sucesso:
                        aoFinalizar(resultado)
                    case .falha(let erro):
                        withAnimation {
                            erroLocal = erro
                        }
                    }
                }
            } catch {
                await MainActor.run {
                    withAnimation {
                        erroLocal = "Erro de conexão com o servidor."
                    }
                }
            }
        }
    }

    private func executarOperacaoRemota(valor: Double) async throws -> ResultadoAPIDTO {
        let contaId = conta.id
        let api = BancoAPIClient.shared

        switch acao {
        case .depositar:
            return try await api.depositar(contaId: contaId, valor: valor)

        case .sacar:
            return try await api.sacar(contaId: contaId, valor: valor)

        case .pix:
            guard let destinoId = contaDestinoId else { throw URLError(.badURL) }
            let dto = try await api.pagar(tipo: "PIX", origemId: contaId, destinoId: destinoId, valor: valor)
            return ResultadoAPIDTO(sucesso: dto.sucesso, id: nil, novoValor: dto.valor, erro: dto.sucesso ? nil : dto.mensagem)

        case .pagEspecie:
            guard let destinoId = contaDestinoId else { throw URLError(.badURL) }
            let dto = try await api.pagar(tipo: "ESPECIE", origemId: contaId, destinoId: destinoId, valor: valor)
            return ResultadoAPIDTO(sucesso: dto.sucesso, id: nil, novoValor: dto.valor, erro: dto.sucesso ? nil : dto.mensagem)

        case .transferencia:
            guard let destinoId = contaDestinoId else { throw URLError(.badURL) }
            let dto = try await api.pagar(tipo: "TRANSFERENCIA", origemId: contaId, destinoId: destinoId, valor: valor)
            return ResultadoAPIDTO(sucesso: dto.sucesso, id: nil, novoValor: dto.valor, erro: dto.sucesso ? nil : dto.mensagem)

        case .salario:
            let dto = try await api.registrarSalario(contaId: contaId, valor: valor)
            if dto.sucesso {
                await MainActor.run {
                    conta.atualizarSalario(valor)
                }
            }
            return dto

        case .solicitarEmprestimo:
            let dto = try await api.solicitarEmprestimo(contaId: contaId, valor: valor)

            if dto.aprovado {
                await MainActor.run {
                    conta.registrarEmprestimo(valor)
                }

                return ResultadoAPIDTO(
                    sucesso: true,
                    id: nil,
                    novoValor: conta.saldo,
                    erro: nil
                )
            } else {
                return ResultadoAPIDTO(
                    sucesso: false,
                    id: nil,
                    novoValor: nil,
                    erro: dto.mensagem
                )
            }

        case .solicitarCartao:
            let cartao = try await api.solicitarCartao(titular: conta.nome, limite: max(conta.salario * 0.3, 1000))

            if let id = cartao.id {
                await MainActor.run {
                    conta.atualizarCartao(id: id, limite: cartao.limite)
                }
            }

            return ResultadoAPIDTO(sucesso: true, id: nil, novoValor: conta.saldo, erro: nil)

        case .aumentarLimiteCartao:
            guard let cartaoId = conta.cartaoId else {
                return ResultadoAPIDTO(sucesso: false, id: nil, novoValor: nil, erro: "A conta não possui cartão cadastrado.")
            }

            _ = try await api.aumentarLimite(cartaoId: cartaoId)

            let cartaoAtualizado = try await api.buscarCartao(cartaoId: cartaoId)
            await MainActor.run {
                conta.atualizarLimiteCartao(cartaoAtualizado.limite)
            }

            return ResultadoAPIDTO(sucesso: true, id: nil, novoValor: conta.saldo, erro: nil)

        case .dadosCadastrais:
            return ResultadoAPIDTO(sucesso: true, id: conta.id, novoValor: conta.saldo, erro: nil)
        }
    }

    private func carregarDadosCadastrais() async {
        await MainActor.run { carregandoDados = true }

        do {
            let salario = try await BancoAPIClient.shared.buscarSalario(contaId: conta.id)

            await MainActor.run {
                conta.atualizarSalario(salario)
            }

            if let cartaoId = conta.cartaoId {
                let cartao = try await BancoAPIClient.shared.buscarCartao(cartaoId: cartaoId)
                await MainActor.run {
                    conta.atualizarLimiteCartao(cartao.limite)
                }
            }
        } catch {
            await MainActor.run {
                erroLocal = "Não foi possível carregar todos os dados cadastrais."
            }
        }

        await MainActor.run { carregandoDados = false }
    }

    private func rotulo(_ texto: String) -> some View {
        Text(texto)
            .font(.system(size: 10, weight: .bold))
            .tracking(1.5)
            .foregroundStyle(.branco.opacity(0.5))
    }
}
