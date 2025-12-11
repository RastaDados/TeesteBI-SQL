CREATE VIEW VW_Top_5_Supervisores_Rank AS
WITH Desempenho_Supervisor AS (
    -- Agrega o desempenho do Vendedor para o nível do Supervisor
    SELECT
        SUPERVISOR,
        SUM(Total_Vidas_Vendedor) AS Total_Vidas,
        SUM(Total_Adesao_Vendedor) AS Total_Adesao
    FROM
        VW_Desempenho_Vendedor_Geral
    GROUP BY
        SUPERVISOR
)
SELECT
    SUPERVISOR,
    Total_Vidas,            -- Faturamento Geral: Vidas
    Total_Adesao,           -- Faturamento Geral: R$ Adesão
    -- Classificação: Vidas (DESC) e, em caso de empate, R$ Adesão (DESC)
    ROW_NUMBER() OVER (
        ORDER BY
            Total_Vidas DESC,
            Total_Adesao DESC
    ) AS Rank_Supervisor
FROM
    Desempenho_Supervisor;

SELECT * FROM VW_Top_5_Supervisores_Rank;