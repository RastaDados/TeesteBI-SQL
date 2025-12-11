CREATE OR ALTER VIEW VW_Distribuicao_Vendas_Tipo AS
WITH Vendas_Tipo AS (
    -- ... (Lógica de Vendas_Tipo e Total_Supervisor permanece a mesma)
    SELECT
        VS.SUPERVISOR,
        'Individual' AS Tipo_Venda,
        SUM(I.Vidas) AS Vidas,
        SUM(I.[R$ Adesão]) AS Adesao
    FROM
        INDIVIDUAL I
    INNER JOIN
        vendedores VS ON I.[Cod# Vendedor] = VS.[COD VENDEDOR]
    GROUP BY VS.SUPERVISOR

    UNION ALL

    SELECT
        VS.SUPERVISOR,
        'Empresarial' AS Tipo_Venda,
        SUM(E.Vidas) AS Vidas,
        SUM(E.[R$ Adesão]) AS Adesao
    FROM
        EMPRESARIAL E
    INNER JOIN
        vendedores VS ON E.[Cod# Vendedor] = VS.[COD VENDEDOR]
    GROUP BY VS.SUPERVISOR
),
Total_Supervisor AS (
    SELECT
        SUPERVISOR,
        SUM(Vidas) AS Total_Vidas_Geral,
        SUM(Adesao) AS Total_Adesao_Geral
    FROM
        Vendas_Tipo
    GROUP BY
        SUPERVISOR
)
SELECT
    TSR.Rank_Supervisor, -- Rank INCLUÍDO
    VT.SUPERVISOR,
    VT.Tipo_Venda,
    VT.Vidas,
    VT.Adesao,
    (CAST(VT.Vidas AS DECIMAL) * 100) / TS.Total_Vidas_Geral AS Perc_Vidas,
    (CAST(VT.Adesao AS DECIMAL) * 100) / TS.Total_Adesao_Geral AS Perc_Adesao
FROM
    Vendas_Tipo VT
INNER JOIN
    VW_Top_5_Supervisores_Rank TSR ON VT.SUPERVISOR = TSR.SUPERVISOR
INNER JOIN
    Total_Supervisor TS ON VT.SUPERVISOR = TS.SUPERVISOR
WHERE
    TSR.Rank_Supervisor <= 5
-- ORDER BY é geralmente aplicado na consulta final, não na VIEW, mas o TSR.Rank_Supervisor deve estar aqui:
-- Não é necessário ORDER BY em VIEWs
;

SELECT
    Rank_Supervisor,
    SUPERVISOR,
    Tipo_Venda,
    Vidas,
    Adesao AS Adesao_R$,
    CAST(Perc_Vidas AS DECIMAL(5, 2)) AS Percentual_Vidas,
    CAST(Perc_Adesao AS DECIMAL(5, 2)) AS Percentual_Adesao
FROM
    VW_Distribuicao_Vendas_Tipo
ORDER BY
    Rank_Supervisor,
    Tipo_Venda DESC;