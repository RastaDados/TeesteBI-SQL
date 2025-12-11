CREATE VIEW VW_Top_5_Vendedores_Por_Supervisor AS
SELECT
    DV.SUPERVISOR,
    DV.VENDEDOR,
    DV.[COD VENDEDOR],
    DV.Total_Vidas_Vendedor,
    DV.Total_Adesao_Vendedor,
    -- Classificação do Vendedor DENTRO de cada Supervisor
    ROW_NUMBER() OVER (
        PARTITION BY DV.SUPERVISOR -- A classificação é reiniciada para cada Supervisor
        ORDER BY
            DV.Total_Vidas_Vendedor DESC,
            DV.Total_Adesao_Vendedor DESC
    ) AS Rank_Vendedor_Supervisor
FROM
    VW_Desempenho_Vendedor_Geral DV
INNER JOIN
    VW_Top_5_Supervisores_Rank TSR ON DV.SUPERVISOR = TSR.SUPERVISOR
WHERE
    TSR.Rank_Supervisor <= 5; -- Filtra apenas os Top 5 Supervisores

    -- Exibir a View
   SELECT
    SUPERVISOR,
    Rank_Vendedor_Supervisor,
    VENDEDOR,
    Total_Vidas_Vendedor AS Vidas_Vendedor,
    Total_Adesao_Vendedor AS Adesao_Vendedor
FROM
    VW_Top_5_Vendedores_Por_Supervisor
WHERE
    Rank_Vendedor_Supervisor <= 5 -- ESTE É O FILTRO CRUCIAL!
ORDER BY
    SUPERVISOR,
    Rank_Vendedor_Supervisor;