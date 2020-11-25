
INSERT INTO grupo (descrip) VALUES ('bpm')
INSERT INTO grupo (descrip) VALUES ('poes')
INSERT INTO grupo (descrip) VALUES ('haccp')

INSERT INTO [control] (descrip, id_grupo) VALUES ('Indumentaria de trabajo',1)
INSERT INTO [control] (descrip, id_grupo) VALUES ('Lavado de manos',1)
INSERT INTO [control] (descrip, id_grupo) VALUES ('Hábitos',1)
INSERT INTO [control] (descrip, id_grupo) VALUES ('Mercaderia estacionada',1)
INSERT INTO [control] (descrip, id_grupo) VALUES ('Mercaderia identificada',1)
INSERT INTO [control] (descrip, id_grupo) VALUES ('Etiquetado y control de envasado',1)
INSERT INTO [control] (descrip, id_grupo) VALUES ('Temperatura del producto',1)
INSERT INTO [control] (descrip, id_grupo) VALUES ('Temperatura de sala',1)
INSERT INTO [control] (descrip, id_grupo) VALUES ('Temperatura de agua',1)
INSERT INTO [control] (descrip, id_grupo) VALUES ('Puertas / cortinas cerradas',1)
INSERT INTO [control] (descrip, id_grupo) VALUES ('utilizacion de canastos, tarimas y utensillos',1)
INSERT INTO [control] (descrip, id_grupo) VALUES ('Pisos secos',1)
INSERT INTO [control] (descrip, id_grupo) VALUES ('Condensación',1)
INSERT INTO [control] (descrip, id_grupo) VALUES ('Estado de estaciones',1)
INSERT INTO [control] (descrip, id_grupo) VALUES ('Ausencia de evidencia de plagas',1)
INSERT INTO [control] (descrip, id_grupo) VALUES ('Cocina',1)

INSERT INTO [control] (descrip, id_grupo) VALUES ('Limpieza operacional del sector',2)
INSERT INTO [control] (descrip, id_grupo) VALUES ('Limpieza de equipos, herramientas etc.',2)
INSERT INTO [control] (descrip, id_grupo) VALUES ('Limpieza de filtros sanitarios',2)
INSERT INTO [control] (descrip, id_grupo) VALUES ('Estado de superficies',2)
INSERT INTO [control] (descrip, id_grupo) VALUES ('Estado de máquinas',2)
INSERT INTO [control] (descrip, id_grupo) VALUES ('Estado de partes metálicas',2)
INSERT INTO [control] (descrip, id_grupo) VALUES ('Estado de desagues',2)
INSERT INTO [control] (descrip, id_grupo) VALUES ('Estado de luminaria quemada',2)
INSERT INTO [control] (descrip, id_grupo) VALUES ('Temperatura de playa',2)
INSERT INTO [control] (descrip, id_grupo) VALUES ('Temperatura de eviscerado 1',2)
INSERT INTO [control] (descrip, id_grupo) VALUES ('Comedor',2)

INSERT INTO [control] (descrip, id_grupo) VALUES ('Playa control de aturdidor',3)
INSERT INTO [control] (descrip, id_grupo) VALUES ('Desplume escaldador',3)
INSERT INTO [control] (descrip, id_grupo) VALUES ('Desplume lavador 1',3)
INSERT INTO [control] (descrip, id_grupo) VALUES ('Desplume escaldador de garras',3)
INSERT INTO [control] (descrip, id_grupo) VALUES ('Eviscerado control de lavadores',3)
INSERT INTO [control] (descrip, id_grupo) VALUES ('Eviscerado control carcazas post',3)
INSERT INTO [control] (descrip, id_grupo) VALUES ('Menudencias enfriamiento',3)
INSERT INTO [control] (descrip, id_grupo) VALUES ('Empaque chiller de garras',3)
INSERT INTO [control] (descrip, id_grupo) VALUES ('Empaque control de chiller y pre chiller',3)

select * 
from control c
join grupo g on c.id_grupo = g.Id

select * from control

INSERT INTO PlanCab (descrip, fch) VALUES ('Plan diario','11/24/2020')
INSERT INTO PlanCab (descrip, fch) VALUES ('Plan diario','11/25/2020')

INSERT INTO PlanDet(id_control, id_PlanCab, aceptable) 
SELECT	Id				AS id_Control, 
		2				AS id_PlanCab,
		XA1.aceptable
FROM	Control
		CROSS APPLY(
			SELECT IIF(ABS(CHECKSUM(NewId())) % 99 > 20,1,0) AS aceptable 
		) AS XA1

INSERT INTO PlanDet(id_control, id_PlanCab, aceptable) 
SELECT	Id				AS id_Control, 
		3				AS id_PlanCab,
		XA1.aceptable
FROM	Control
		CROSS APPLY(
			SELECT IIF(ABS(CHECKSUM(NewId())) % 99 > 50,1,0) AS aceptable 
		) AS XA1


