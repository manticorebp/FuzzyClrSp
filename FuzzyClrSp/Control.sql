CREATE TABLE [dbo].[Control]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [descrip] NVARCHAR(50) NULL, 
    [id_grupo] INT NOT NULL, 
    CONSTRAINT [FK_Control_Grupo] FOREIGN KEY ([id_grupo]) REFERENCES [grupo]([id])
)
