CREATE VIEW VW_Ticket_Medio_Supervisor AS
SELECT
    TSR.SUPERVISOR,
    TSR.Rank_Supervisor,
    SUM(CMC.Vidas) AS Total_Vidas,
    SUM(CMC.[R$ Adesão]) AS Total_Adesao,
    SUM(CMC.[Qtd Contrato]) AS Total_Contratos,
    -- Ticket Médio por Vida (R$ Adesão / Vidas)
    CASE
        WHEN SUM(CMC.Vidas) > 0 THEN SUM(CMC.[R$ Adesão]) / SUM(CMC.Vidas)
        ELSE 0
    END AS Ticket_Medio_Por_Vida,
    -- Ticket Médio por Contrato (R$ Adesão / Qtd Contrato)
    CASE
        WHEN SUM(CMC.[Qtd Contrato]) > 0 THEN SUM(CMC.[R$ Adesão]) / SUM(CMC.[Qtd Contrato])
        ELSE 0
    END AS Ticket_Medio_Por_Contrato
FROM
    VW_Consolidado_Metricas_Completas CMC
INNER JOIN
    VW_Top_5_Supervisores_Rank TSR ON CMC.SUPERVISOR = TSR.SUPERVISOR
WHERE
    TSR.Rank_Supervisor <= 5 -- Foca apenas no Top 5
GROUP BY
    TSR.SUPERVISOR,
    TSR.Rank_Supervisor;


SELECT * FROM VW_Ticket_Medio_Supervisor
ORDER BY Ticket_Medio_Por_Vida DESC;