CREATE VIEW dbo.vw_SKUPrice AS
SELECT ID, Code, Name, dbo.udf_GetSKUPrice(ID) AS Price
FROM dbo.SKU;