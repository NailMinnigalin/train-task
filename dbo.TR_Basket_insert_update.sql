CREATE TRIGGER dbo.TR_Basket_insert_update ON dbo.Basket AFTER INSERT
AS
BEGIN
	-- predicat is: was inserted 2 or more rows and all of them have the same ID_SKU
	DECLARE @Predicat BIT = 1;

	-- was insered 2 or more strings
	DECLARE @Count INT;
	SELECT @Count = COUNT(*) FROM inserted
	IF @Count < 2 
		SELECT @Predicat = 0;

	-- all string have one ID_SKU
	IF EXISTS (SELECT bas1.ID FROM inserted bas1 JOIN inserted bas2 ON bas1.ID > bas2.ID WHERE bas1.ID_SKU <> bas2.ID_SKU) SELECT @Predicat = 0;


	UPDATE 
		dbo.Basket
	SET 
		DiscountValue = CASE WHEN @Predicat = 1 THEN Value * 0.05 ELSE 0 END
	WHERE 
		dbo.Basket.ID IN (SELECT ins.ID FROM inserted AS ins);
END;