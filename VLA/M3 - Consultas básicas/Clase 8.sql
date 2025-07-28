-- Clientes sin pedidos
select c.ContactName,
       c.CustomerID,
       c.CompanyName

from Customers c
         left join Invoices i on c.CustomerID = i.CustomerID
where i.CustomerID is null;

select c.ContactName,
       c.CustomerID,
       c.CompanyName
from Customers c
         inner join Invoices i on c.CustomerID = i.CustomerID
where i.CustomerID is not null;

-- Total de pedidos por cliente
select c.CustomerID,
       count(*) as TotalCustomersWithOrders
from Orders o
         join Customers c on o.CustomerID = c.CustomerID
group by c.CustomerID

select *
from Orders

-- Contar los clientes que tiene la empresa
select count(*) as TotalCustomers
from Customers

-- Listar productos más vendidos
select p.ProductID,
       p.ProductName,
       SUM(od.Quantity) as TotalSold
from [Order Details] od
         join Products p on od.ProductID = p.ProductID
group by p.ProductID, p.ProductName
order by TotalSold desc;

--## Opción del docente
select *
from Invoices
select ProductName,
       ProductID,
       SUM(Quantity) AS TotalQuantity
from Invoices
group by ProductName, ProductID;

-- Inventarios actual de productos
select ProductName, UnitsInStock
from Products

-- Listar productos vencidos
select p.ProductID,
       p.ProductName,
       p.UnitsInStock,
       p.Discontinued
from Products p
where p.Discontinued = 1
-- order by p.ProductName;

-- Listar cuantos estan vencidos
select count(*) as TotalDiscontinuedProducts
from Products p
where p.Discontinued = 1;

-- Lista de ventas que no han sido enviadas, tome en cuenta el
-- pais, la ciudad, nomber del producto, el nombre del cliente
select c.ContactName,
       c.CustomerID,
       c.CompanyName,
       p.ProductName,
       i.ShippedDate,
       i.ShipCountry,
       i.ShipCity
from Customers c
         inner join Invoices i on c.CustomerID = i.CustomerID
         left join Products p on i.ProductID = p.ProductID
where i.ShippedDate is null

select *
from Invoices
where ShippedDate is null;

-- Productos con categoría que no estén vencidos
select p.ProductID,
       p.ProductName,
       p.UnitsInStock,
       p.Discontinued,
       c.CategoryName
from Products p
         inner join Categories c on p.CategoryID = c.CategoryID
where p.Discontinued = 0


SELECT FORMAT(ShippedDate, 'dddd, dd yyyy') as FormattedDate,
       SUM(ExtendedPrice)                   as TotalSales
FROM Invoices
WHERE YEAR(ShippedDate) = 1997
GROUP BY FORMAT(ShippedDate, 'dddd, dd MMMM yyyy')
HAVING SUM(ExtendedPrice) > 100;

-- ============= insertar datos dentro de factura ==============
INSERT INTO PEDIDOS
VALUES (1, 1, getdate(), 3)

-- insertar dentro de factura
declare @desc int=10
INSERT INTO FACTURA (ID_PEDIDOS, TOTAL, FECHA_FACTURA)

SELECT p.ID                                                                     as ID_PEDIDOS,
       SUM((P.CANTIDAD * pr.PRECIO) - ((P.CANTIDAD * pr.PRECIO) * @desc / 100)) AS Total,
       GETDATE()                                                                AS FECHA
FROM PEDIDOS p
         JOIN PRODUCTOS pr ON p.ID_PRODUCTO = pr.ID
WHERE p.ID = 5
GROUP BY p.ID

-- Insertar en factura, ejercicio del curso
CREATE TABLE Facturas
(
    IdFactura     int IDENTITY (1,1) PRIMARY KEY,
    IDPEDIDO      INT            NOT NULL,
    SUBTOTAL      DECIMAL(10, 2) NOT NULL,
    DESCUENTO     DECIMAL(10, 2),
    DESC_TOTAL    DECIMAL(10, 2),
    TOTAL         DECIMAL(10, 2) NOT NULL,
    FECHA_FACTURA DATE           NOT NULL
        FOREIGN KEY (IDPEDIDO) REFERENCES PEDIDOS (ID)
)

DECLARE @desc int = 10;

INSERT INTO Facturas (IDPEDIDO, SUBTOTAL, DESCUENTO, DESC_TOTAL, TOTAL, FECHA_FACTURA)
SELECT P.ID,
       SUM(P.CANTIDAD * pr.PRECIO)                                              AS Total,
       @desc                                                                    AS Descuento,
       SUM(P.CANTIDAD * pr.PRECIO) * @desc / 100                                AS DescTotal,
       SUM((P.CANTIDAD * pr.PRECIO) - ((P.CANTIDAD * pr.PRECIO) * @desc / 100)) AS Total,
       GETDATE()                                                                AS FECHA
FROM PEDIDOS p
         JOIN PRODUCTOS pr ON p.ID_PRODUCTO = pr.ID
WHERE p.ID = 5
GROUP BY p.ID
