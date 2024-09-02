--Ejercicios 3.
--Crear una vista que retorne el listado de todos los cuartos que tienen alto grado de cancelación,
--pueden definir ese grado de cancelación como un porcentaje de reservaciones canceladas.
--Debe usar subqueries la calcular ese porcentaje y un join que incluya todos los cuartos incluyendo
--aquellos que nunca han tenido una reservación

CREATE VIEW CuartosConAlto
AS
SELECT
	r.RoomID,
	r.RoomName,
	r.RoomType,
	r.Capacity,
	r.Rate,
	ISNULL(canceladas.CantidadCancelaciones, 0) AS CantidadCancelaciones,
    ISNULL(totales.CantidadReservaciones, 0) AS CantidadReservaciones,
    ISNULL(CASE WHEN totales.CantidadReservaciones > 0 
                THEN (CAST(canceladas.CantidadCancelaciones AS FLOAT) / totales.CantidadReservaciones) * 100 
                ELSE 0 END, 0) AS PorcentajeCancelacion

FROM Rooms r

LEFT JOIN 
    (SELECT 
        RoomID, 
        COUNT(*) AS CantidadCancelaciones 
     FROM 
        Bookings 
     WHERE 
        Status = 'Cancelada' 
     GROUP BY 
        RoomID) canceladas ON r.RoomID = canceladas.RoomID
LEFT JOIN 
    (SELECT 
        RoomID, 
        COUNT(*) AS CantidadReservaciones 
     FROM 
        Bookings 
     GROUP BY 
        RoomID) totales ON r.RoomID = totales.RoomID