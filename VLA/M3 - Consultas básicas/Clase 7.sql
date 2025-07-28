-- Resumen de ventas por año
select year(i.OrderDate)      as OrderYear,
       sum(i.ExtendedPrice)   as TotalAmount,
       count(i.ExtendedPrice) as CountAmount,
       avg(i.ExtendedPrice)   as AvgAmount,
       max(i.ExtendedPrice)   as MaxAmount,
       Min(i.ExtendedPrice)   as MinAmount
from Invoices as i
group by year(i.OrderDate)
;

-- 3 ventas con mayor cantidad
select top 3 OrderID, YEAR(OrderDate) as año, ProductID, Quantity, UnitPrice
from Invoices
order by Quantity desc
;

-- Mostar un mensaje si el precio es mayor a 100
select OrderID,
       YEAR(OrderDate),
       ProductName,
       Quantity,
       UnitPrice,
       iif(UnitPrice > 100, 'precio alto', 'precio normal') as Estado
from Invoices
;

-- clasificas las ventas según la cantidad facuturada  por año
DECLARE @COMBO INT =1997
SELECT YEAR(OrderDate) as OrderYear,
       case
           when ExtendedPrice < 1000 then 'Baja'
           when ExtendedPrice BETWEEN 1000 and 5000 then 'Media'
           when ExtendedPrice >= 5000 then 'Alta'
           end         as kind
FROM Invoices
WHERE YEAR(OrderDate) = @COMBO
ORDER BY ExtendedPrice DESC
-- group by YEAR(OrderDate)
;

-- TOTAL DE VENTAS POR PRODUCTO, CON SU PROMEDIO
select ProductName,
       SUM(Quantity)  AS TotalQuantity,
       AVG(UnitPrice) AS AvgUnitPrice
from Invoices
GROUP BY ProductName

-- Mostrar las fechas en años con mas de 5 ventas
select *
from Invoices

SELECT YEAR(ShippedDate) AS ShippedYear,
       COUNT(*)          AS TotalOrders
FROM Invoices
GROUP BY ShippedDate
HAVING COUNT(*) > 5
ORDER BY ShippedDate DESC

-- Obtener los productos de una categoría específica
SELECT *
from Products
WHERE CategoryID = 4
order by ProductName;

-- 1. Obtener el total de ventas [Facturas] por año
SELECT year(OrderDate) as Year, COUNT(*) as Total
FROM Invoices
GROUP BY year(OrderDate)

-- 2. Obtener el promedio de ventas por cliente
SELECT CustomerID,
       AVG(ExtendedPrice) as Prom
FROM Invoices
GROUP BY CustomerID

-- 3. Obtener las facturas con un total mayor a $500
Select *
from Invoices
where ExtendedPrice > 500

-- 4. Obtener el número total de facturas por cliente, pero solo para aquellos que han realizado más de 2 facturas
select CustomerID,
       COUNT(ExtendedPrice) as Prom
from Invoices
group by CustomerID
having COUNT(ExtendedPrice) > 2

-- 5. Obtener el número de facturas por año y mes, ordenado por año y mes
select YEAR(OrderDate)  as year,
       MONTH(OrderDate) as month,
       count(*)         as total
from Invoices
group by YEAR(OrderDate), MONTH(OrderDate)
order by year, month

-- Obtener las facturas con el total más alto
SELECT TOP 1 *
FROM Invoices
ORDER BY ExtendedPrice DESC;

--  Obtener el total de ventas para cada cliente, mostrando "Cliente nuevo"
--  si su primera factura es 1997
select CustomerID,
       Sum(ExtendedPrice) as TotalSales,
       case
           when MIN(YEAR(OrderDate)) = 1997 then 'Cliente nuevo'
           else CAST(Sum(ExtendedPrice) as varchar(20))
       end as CustomerType
from Invoices
group by CustomerID

-- 8. Obtener la factura con la fecha más reciente:
select top 1 *
    from Invoices
order by OrderDate desc
-- 9. Obtener el promedio de ventas mensuales para todo el conjunto de datos:
select YEAR(OrderDate) as Year,
       MONTH(OrderDate) as Month,
       AVG(ExtendedPrice) as AvgMonthlySales
from Invoices
group by YEAR(OrderDate), MONTH(OrderDate)
order by year, Month;

select OrderDate,
       AVG(ExtendedPrice) as AvgMonthlySales
from Invoices
group by OrderDate
order by OrderDate;
-- 10. Obtener el total de ventas por día para el año 1997[mostrar los días como: lunes 19 de febrero
-- del 1997], excluyendo los días con ventas totales inferiores a $100:
SELECT FORMAT(ShippedDate, 'dddd dd MMMM yyyy') as FormattedDate,
       AVG(ExtendedPrice) as AvgSales
FROM Invoices
WHERE YEAR(ShippedDate) = 1997
GROUP BY FORMAT(ShippedDate, 'dddd dd MMMM yyyy')
HAVING SUM(ExtendedPrice) > 100;

-- Hacer una ventas, usando INSERT INTO dentro de la consulta FACTURA, que realice los
-- cálculos de PRECIO * CANTIDAD, para obtener el total, la tabla FACTURA, de tener los
-- siguientes campos: IdFactura,IdPedido,Subtotal,Descuento,Desc_Total,
-- Total,Fecha_Factura
select CustomerID,
       YEAR(OrderDate)
from Invoices
group by CustomerID, YEAR(OrderDate)


