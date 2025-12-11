CREATE VIEW VW_Desempenho_Vendedor_Geral AS
WITH Vendas_Consolidadas AS (
    -- Combina as vendas Individual e Empresarial
    SELECT [Cod# Vendedor], Vidas, [R$ Adesão] FROM INDIVIDUAL
    UNION ALL
    SELECT [Cod# Vendedor], Vidas, [R$ Adesão] FROM EMPRESARIAL
)
SELECT
    VS.SUPERVISOR,
    VS.VENDEDOR,
    VS.[COD VENDEDOR],
    VS.PRAÇA,
    SUM(VC.Vidas) AS Total_Vidas_Vendedor,
    SUM(VC.[R$ Adesão]) AS Total_Adesao_Vendedor
FROM
    Vendas_Consolidadas VC
INNER JOIN
    vendedores VS ON VC.[Cod# Vendedor] = VS.[COD VENDEDOR]
GROUP BY
    VS.SUPERVISOR,
    VS.VENDEDOR,
    VS.[COD VENDEDOR],
    VS.PRAÇA;



    SELECT * FROM VW_Desempenho_Vendedor_Geral
    ORDER BY Total_Vidas_Vendedor DESC;