# ⚙️ Projeto Lógico de Banco de Dados: Gestão de Oficina Mecânica

Este projeto consiste na modelagem e implementação de um esquema de banco de dados relacional (DDL e DML) para gerenciar as operações de uma oficina mecânica, focando no controle e execução de Ordens de Serviço (OS).

O objetivo é rastrear clientes, veículos, equipes de mecânicos, peças utilizadas e serviços executados em cada OS, permitindo o cálculo preciso do valor total.

## 🛠️ Tecnologias Utilizadas

* **Modelagem:** Diagrama de Entidade-Relacionamento (DER) e Modelo Lógico.
* **SGBD:** MySQL (O script SQL está otimizado para este ambiente).
* **Linguagem:** SQL (Data Definition Language - DDL e Data Manipulation Language - DML).

## 📊 Estrutura do Banco de Dados

O modelo é composto por **10 tabelas**, incluindo 3 tabelas associativas para resolver relacionamentos de muitos-para-muitos (N:N).

### Entidades Principais

| Entidade | Descrição |
| :--- | :--- |
| `CLIENTE` | Cadastro do proprietário do veículo. |
| `VEICULO` | Informações do carro (identificado pela `placa`). |
| `MECANICO` | Profissionais da oficina e suas especialidades. |
| `EQUIPE` | Agrupamento de mecânicos para designação de OS. |
| `OS` | A Ordem de Serviço, com status e data de conclusão prevista. |
| `SERVICO` | Tabela de referência para preços de mão de obra. |
| `PECA` | Tabela de referência para peças e seus valores unitários. |

### Relacionamentos Chave (Tabelas Associativas)

* `MECANICO_EQUIPE`: Liga `MECANICO` a `EQUIPE`.
* `ITENS_SERVICO`: Detalha quais serviços (mão de obra) foram realizados em cada `OS`.
* `ITENS_PECA`: Detalha quais peças foram utilizadas em cada `OS`, registrando a quantidade e o valor total.

## 🚀 Como Executar o Projeto

O projeto pode ser executado em qualquer ambiente MySQL (Workbench, phpMyAdmin, ou terminal).

### 1. Obtenha o Script

O arquivo principal do projeto é o `oficina_mecanica_completo.sql`.

### 2. Execução

1.  Abra o cliente MySQL de sua preferência (ex: MySQL Workbench).
2.  Copie e cole **todo** o conteúdo do arquivo `oficina_mecanica_completo.sql` em uma nova aba de consulta.
3.  Execute o script.

Este script irá:
1.  Criar o esquema (`OficinaMecanica`).
2.  Criar todas as 10 tabelas (DDL).
3.  Inserir dados de teste (DML) em todas as tabelas, incluindo duas Ordens de Serviço completas para demonstração.

## 🔍 Consultas de Demonstração (Queries)

Para validar o funcionamento do modelo, você pode executar as seguintes consultas após a população da base:

### 1. Detalhar o Valor Final da OS (num_os = 1)

```sql
SELECT
    OS.num_os,
    SUM(S.preco_mao_de_obra) AS Total_MaoDeObra,
    SUM(IP.valor_total_peca) AS Total_Pecas,
    (SUM(S.preco_mao_de_obra) + SUM(IP.valor_total_peca)) AS Valor_Final_Calculado
FROM OS
LEFT JOIN ITENS_SERVICO AS IS ON OS.num_os = IS.num_os
LEFT JOIN SERVICO AS S ON IS.id_servico = S.id_servico
LEFT JOIN ITENS_PECA AS IP ON OS.num_os = IP.num_os
WHERE OS.num_os = 1
GROUP BY OS.num_os;
