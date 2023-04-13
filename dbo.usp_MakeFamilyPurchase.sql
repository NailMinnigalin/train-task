CREATE PROCEDURE dbo.usp_MakeFamilyPurchase
	@FamilySurName VARCHAR(255)
AS
BEGIN
	IF NOT EXISTS(SELECT 1 FROM dbo.Family WHERE SurName = @FamilySurName)
    BEGIN
		DECLARE @msg VARCHAR(255) = FORMATMESSAGE(N'There is no family with the surname %s', @FamilySurName);
		THROW 50000, @msg, 1;
    END;

    UPDATE dbo.Family
    SET BudgetValue = BudgetValue - (
        SELECT SUM(Value)
        FROM dbo.Basket
        WHERE ID_Family = family.ID
    )
    FROM dbo.Family family
    WHERE SurName = @FamilySurName;
END