CREATE VIEW VW_Top_5_Pracas_Por_Supervisor AS
WITH Desempenho_Praca AS (
    -- Agrega o desempenho de Vendedores para o nível de Praça
    SELECT
        SUPERVISOR,
        PRAÇA,
        SUM(Total_Vidas_Vendedor) AS Total_Vidas_Praca,
        SUM(Total_Adesao_Vendedor) AS Total_Adesao_Praca
    FROM
        VW_Desempenho_Vendedor_Geral
    GROUP BY
        SUPERVISOR,
        PRAÇA
)
SELECT
    DP.SUPERVISOR,
    DP.PRAÇA,
    DP.Total_Vidas_Praca,
    DP.Total_Adesao_Praca,
    -- Classificação da Praça DENTRO de cada Supervisor
    ROW_NUMBER() OVER (
        PARTITION BY DP.SUPERVISOR
        ORDER BY
            DP.Total_Vidas_Praca DESC,
            DP.Total_Adesao_Praca DESC
    ) AS Rank_Praca_Supervisor
FROM
    Desempenho_Praca DP
INNER JOIN
    VW_Top_5_Supervisores_Rank TSR ON DP.SUPERVISOR = TSR.SUPERVISOR
WHERE
    TSR.Rank_Supervisor <= 5; -- Filtra apenas os Top 5 Supervisores



SELECT
    SUPERVISOR,
    Rank_Praca_Supervisor,
    PRAÇA,
    Total_Vidas_Praca AS Vidas_Praca,
    Total_Adesao_Praca AS Adesao_Praca
FROM
    VW_Top_5_Pracas_Por_Supervisor
WHERE
    Rank_Praca_Supervisor <= 5
ORDER BY
    SUPERVISOR,
    Rank_Praca_Supervisor;