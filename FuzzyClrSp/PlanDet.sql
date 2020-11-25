CREATE TABLE [dbo].[PlanDet]
(
	[Id] INT NOT NULL PRIMARY KEY IDENTITY, 
    [id_PlanCab] INT NOT NULL,
    [id_control] INT NOT NULL, 
    [aceptable] BIT NOT NULL, 
    CONSTRAINT [FK_PlanDet_Control] FOREIGN KEY ([id_control]) REFERENCES [Control]([id]), 
    CONSTRAINT [FK_PlanDet_PlanCab] FOREIGN KEY ([id_PlanCab]) REFERENCES [PlanCab]([id])
)
