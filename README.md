# 📦 Logistic Insights – Análise de Operações Logísticas com SQL e Power BI

**Resumo**  
Projeto que demonstra análise de operações logísticas usando SQL para transformação e consultas analíticas, e Power BI para visualização dos principais KPIs da operação (SLA, atraso, volume por região, transportadoras, lead time).

**Tech stack**
- SQL (MySQL / PostgreSQL / SQLite)
- Power BI (arquivo .pbix para visualização)
- Dados de exemplo em CSV

---

## Objetivos do projeto
- Calcular e analisar KPIs logísticos (SLA, tempo médio de entrega, taxa de entregas no prazo).
- Construir dashboard em Power BI com filtros por período, estado e transportadora.
- Mostrar capacidade de transformar perguntas de negócio em queries SQL e visualizações.

---

## Como usar
1. Importar `data/orders_sample.csv` para seu banco (ou use o script `sql/01_create_table.sql` + `sql/02_load_sample.sql`).
2. Rodar as queries em `sql/10_kpis_queries.sql`.
3. Abrir Power BI e importar `orders_sample.csv` ou conectar ao banco.
4. Criar medidas DAX conforme `powerbi/measures_and_visuals.md` e montar as páginas do dashboard.

---

## Conteúdo do repositório
- `data/` — CSV de exemplo.
- `sql/` — scripts de criação/consulta.
- `powerbi/` — instruções das medidas DAX e layout do dashboard.
- `docs/` — imagens / mockups.

---

## Resultados esperados
- Dashboard com KPIs: SLA (on-time %), Tempo médio de entrega, Pedidos por região, Top transportadoras.
- Queries que respondem perguntas de negócio como: "Quais regiões têm mais atraso?" e "Qual transportadora entrega mais rápido?"

---

## Autor
Yuri Borges — Analista de Dados em formação. Contato: [Yuriborgesybs1@gmail.com]
🔗[LinkedIn](https://www.linkedin.com/in/yuri-borges-dados/)

