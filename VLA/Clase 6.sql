-- contar los registros de customers
select count(*) from Customers;
-- productos en existencia
select * from Products where UnitsInStock > 39;
-- Filtro Like
select QuantityPerUnit from Products where QuantityPerUnit like '24%';
-- Filtro in
select * from Products where ProductName in ('Queso Cabrales', 'Queso Manchego La Pastora');

-- Orders
select * from Orders
-- Filtro con fechas
select * from Orders where ShippedDate between '1997-01-04' and '1997-09-04';
-- Filtro like
select * from Orders where  ShipCountry like  '%br%';
-- Top 10 orders
select top 2 RequiredDate from Orders
-- Abreviatura,
select substring(ShipName, 1, 3) as Abreviatura from Orders;


-- Orders: Ingresos por meses
select * from Orders;
Select * from [Order Details];

SELECT
    YEAR(OrderDate) AS Anio,
    MONTH(OrderDate) AS Mes,
    COUNT(*) AS TotalPedidos
FROM Orders
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
;

-- Detalles de pedidos para un cliente específico, Maria Anders, ALFKI
SELECT
    o.OrderID,
    o.OrderDate,
    o.CustomerID,
    o.ShippedDate,
    od.ProductID,
    od.UnitPrice,
    od.Quantity
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
WHERE o.CustomerID = 'ALFKI'

select * from Customers;