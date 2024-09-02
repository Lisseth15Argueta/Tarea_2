--Ejercicios 2.
--Crear una vista que muestre las tendencias de reservaciones a lo largo del tiempo,
--mostrando el n�mero total de reservaciones y los ingresos totales por mes.
--Utilice subqueries para calcular los totales mensuales y un Right Join para asegurarse
--que se incluyan todos los meses dentro del rango de fechas, incluso si no hay reservaciones.
--La consulta debe mostrar la siguiente informaci�n el a�o, el mes, total de reservaciones y los ingresos totales.

CREATE VIEW VistaTendenciasReservaciones AS
WITH MonthlyData AS (
    SELECT 
        YEAR(BookingDate) AS A�o,
        MONTH(BookingDate) AS Mes,
        COUNT(BookingID) AS TotalReservaciones,
        SUM(TotalAmount) AS IngresosTotales
    FROM 
        Bookings
    GROUP BY 
        YEAR(BookingDate), MONTH(BookingDate)
),
AllMonths AS (
    SELECT 
        DISTINCT YEAR(BookingDate) AS A�o, 
        MONTH(BookingDate) AS Mes
    FROM 
        Bookings
    UNION
    SELECT 
        YEAR(GETDATE()) AS A�o, 
        MONTH(GETDATE()) AS Mes
)
SELECT 
    COALESCE(MD.A�o, AM.A�o) AS A�o,
    COALESCE(MD.Mes, AM.Mes) AS Mes,
    COALESCE(MD.TotalReservaciones, 0) AS TotalReservaciones,
    COALESCE(MD.IngresosTotales, 0) AS IngresosTotales
FROM 
    AllMonths AM
RIGHT JOIN 
    MonthlyData MD ON AM.A�o = MD.A�o AND AM.Mes = MD.Mes;
