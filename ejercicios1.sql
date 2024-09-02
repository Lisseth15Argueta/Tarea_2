--Ejercicios 1.
--Crear una vista para mostrar a los clientes que tienen reservaciones incompletas
--(por ejemplo, reservaciones que no se han pagado en su totalidad o reservasciones que aún están pendientes).
--Use subqueries para filtrar según el estado de la reserva y el estado del pago. Recuerde incluir todos los clientes.
--La consulta debe mostrar la siguiente información id del cliente, nombre del cliente, reservacion id, status de la reservación,
--monto pagado, monto pendiente.

CREATE VIEW Reservacion
AS
SELECT
	c.CustomerID,
	CONCAT(c.FirstName, ' ', c.LastName) AS NombreCliente,
	b.BookingID,
    b.Status AS StatusReservacion,
    COALESCE(SUM(p.Amount), 0) AS MontoPagado,
    b.TotalAmount - COALESCE(SUM(p.Amount), 0) AS MontoPendiente
FROM
	Customers c

INNER JOIN Bookings b ON c.CustomerID = b.CustomerID

LEFT JOIN Payments p ON b.BookingID = p.BookingID

GROUP BY c.CustomerID, c.FirstName, c.LastName, b.BookingID, b.Status, b.TotalAmount

HAVING b.Status = 'Pendiente' OR b.TotalAmount > COALESCE(SUM(P.Amount), 0);
