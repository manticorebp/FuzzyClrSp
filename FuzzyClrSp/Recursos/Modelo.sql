CREATE TABLE [dbo].[Control]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [descrip] NVARCHAR(50) NULL, 
    [id_grupo] INT NOT NULL, 
    CONSTRAINT [FK_Control_Grupo] FOREIGN KEY ([id_grupo]) REFERENCES [grupo]([id])
)
CREATE TABLE [dbo].[Grupo]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [descrip] NVARCHAR(50) NULL
)
CREATE TABLE [dbo].[PlanCab]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [descrip] NVARCHAR(50) NOT NULL, 
    [fch] DATE NOT NULL
)
CREATE TABLE [dbo].[PlanDet]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [id_PlanCab] INT NOT NULL,
    [id_control] INT NOT NULL, 
    [aceptable] BIT NOT NULL, 
    CONSTRAINT [FK_PlanDet_Control] FOREIGN KEY ([id_control]) REFERENCES [Control]([id]), 
    CONSTRAINT [FK_PlanDet_PlanCab] FOREIGN KEY ([id_PlanCab]) REFERENCES [PlanCab]([id])
)

--gacutil -i FuzzyLogicLibrary.dll