-- contar los registros de customers
select count(*)
from Customers;
-- productos en existencia
select *
from Products
where UnitsInStock > 39;
-- Filtro Like
select QuantityPerUnit
from Products
where QuantityPerUnit like '24%';
-- Filtro in
select *
from Products
where ProductName in ('Queso Cabrales', 'Queso Manchego La Pastora');

-- Orders
select *
from Orders
-- Filtro con fechas
select *
from Orders
where ShippedDate between '1997-01-04' and '1997-09-04';
-- Filtro like
select *
from Orders
where ShipCountry like '%br%';
-- Top 10 orders
select top 2 RequiredDate
from Orders
-- Abreviatura,
select substring(ShipName, 1, 3) as Abreviatura
from Orders;


-- Orders: Ingresos por meses
select *
from Orders;
Select *
from [Order Details];

SELECT YEAR(OrderDate)  AS Anio,
       MONTH(OrderDate) AS Mes,
       COUNT(*)         AS TotalPedidos
FROM Orders
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
;

-- Detalles de pedidos para un cliente específico, Maria Anders, ALFKI
SELECT o.OrderID,
       o.OrderDate,
       o.CustomerID,
       o.ShippedDate,
       od.ProductID,
       od.UnitPrice,
       od.Quantity
FROM Orders o
         JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE o.CustomerID = 'ALFKI'

-- Clientes con más de una compra
select *
from Customers;
SELECT c.CustomerID,
       c.CompanyName,
       COUNT(o.OrderID) AS NumeroDeCompras
FROM Customers c
         JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CompanyName
HAVING COUNT(o.OrderID) > 1;

select *
from Invoices;


-- #### Ejemplo de la clase ####
SELECT top 4 i.ProductID, COUNT(i.CustomerID) AS ClientesQueCompraron
from Invoices as i
         inner join Customers as c on i.CustomerID = c.CustomerID
group by i.ProductID
;

-- Ejercicios
-- Ejercicio 1
select *
from Products
where Discontinued = 1

update Products
set Discontinued = 1
where ProductID = 5

select *
from Products
where ProductID = 5

-- Eliminar productos obsoletos con existencia cero
select *
from Products
where UnitsInStock = 0

--     Listar productos con baja existencia para reabastecimiento, poner top
select *
from Products
where UnitsInStock < 4

--     Ajuste de existencias después de una venta
update Products
set UnitsInStock = (select od.Quantity
                    from [Order Details] as od
                             join Products as p on p.ProductID = od.ProductID
                    where od.OrderID = 10285
                      and p.ProductID = 1)
where ProductID = 1

C:/Users/Delta2/Documents/Proyectos/sql/VLA/Clase 6.sql:116

