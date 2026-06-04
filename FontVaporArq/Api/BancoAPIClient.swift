//
//  BancoAPIClient.swift
//  FontVaporArq
//
//  Created by Éverton Alencar de Lima on 02/06/26.
//

// ProjectBanco/Services/BancoAPIClient.swift
import Foundation

private struct ValorRequest: Encodable {
    let valor: Decimal
}

private struct NomeRequest: Encodable {
    let nome: String
}

private struct PixRequest: Encodable {
    let origemId: String
    let destinoId: String
    let valor: Decimal
}

class BancoAPIClient {
    static let shared = BancoAPIClient()

    // URLs base de cada serviço
    private let contaBaseURL = "https://contaprojvaporarquitetura-1.onrender.com"
    private let pagamentoBaseURL  = "http://localhost:8081"  // Java/Spring
    private let cartaoBaseURL     = "http://localhost:8082"  // Java/Spring
    private let emprestimoBaseURL = "http://localhost:8083"  // Java/Spring

    // MARK: - Conta Service (Vapor)

    func criarConta(nome: String, tipo: TipoConta) async throws -> ResultadoAPIDTO {
        let endpoint: String
        switch tipo {
        case .corrente:
            endpoint = "\(contaBaseURL)/contas/corrente"
        case .poupanca:
            endpoint = "\(contaBaseURL)/contas/poupanca"
        case .internacional:
            endpoint = "\(contaBaseURL)/contas/internacional"
        }
        return try await post(url: endpoint, body: NomeRequest(nome: nome))
    }

    func depositar(contaId: UUID, valor: Decimal) async throws -> ResultadoAPIDTO {
        return try await post(url: "\(contaBaseURL)/contas/\(contaId)/depositar",
                              body: ValorRequest(valor: valor))
    }

    func sacar(contaId: UUID, valor: Decimal) async throws -> ResultadoAPIDTO {
        return try await post(url: "\(contaBaseURL)/contas/\(contaId)/sacar",
                              body: ValorRequest(valor: valor))
    }

    func saldo(contaId: UUID) async throws -> ResultadoAPIDTO {
        return try await get(url: "\(contaBaseURL)/contas/\(contaId)/saldo")
    }

    // MARK: - Pagamento Service

    func pix(origemId: UUID, destinoId: UUID, valor: Decimal) async throws -> ResultadoAPIDTO {
        return try await post(url: "\(pagamentoBaseURL)/pagamentos/pix",
                              body: PixRequest(origemId: origemId.uuidString,
                                               destinoId: destinoId.uuidString,
                                               valor: valor))
    }

    
    func transferencia(origemId: UUID, destinoId: UUID, valor: Decimal) async throws -> ResultadoAPIDTO {
        return try await post(url: "\(pagamentoBaseURL)/pagamentos/transferencia",
                              body: PixRequest(origemId: origemId.uuidString,
                                               destinoId: destinoId.uuidString,
                                               valor: valor))
    }

    // MARK: - Helpers HTTP genéricos

    private func post<B: Encodable>(url: String, body: B) async throws -> ResultadoAPIDTO {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(body)
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(ResultadoAPIDTO.self, from: data)
    }

    private func get(url: String) async throws -> ResultadoAPIDTO {
        let (data, _) = try await URLSession.shared.data(from: URL(string: url)!)
        return try JSONDecoder().decode(ResultadoAPIDTO.self, from: data)
    }
}

// DTO que espelha o ResultadoDTO do backend
struct ResultadoAPIDTO: Codable {
    let sucesso: Bool
    let id: UUID?
    let novoValor: Decimal?
    let erro: String?

    // converte para o enum Resultado local (para manter compatibilidade com a UI)
    func toResultado() -> Resultado {
        if sucesso, let valor = novoValor {
            return .sucesso(novoValor: valor)
        }
        return .falha(erro: erro ?? "Erro desconhecido")
    }
}

extension BancoAPIClient {
    func listarContas() async throws -> [ContaDTO] {
        let (data, _) = try await URLSession.shared.data(
            from: URL(string: "\(contaBaseURL)/contas")!
        )

        if let json = String(data: data, encoding: .utf8) {
            print("JSON /contas:", json)
        }

        return try JSONDecoder().decode([ContaDTO].self, from: data)
    }
}
