-- 10. Obtener el total de ventas por día para el año 1997[mostrar los días como: lunes 19 de febrero
-- del 1997], excluyendo los días con ventas totales inferiores a $100:

SELECT FORMAT(ShippedDate, 'dddd dd MMMM yyyy') as FormattedDate,
       AVG(ExtendedPrice) as AvgSales
FROM Invoices
WHERE YEAR(ShippedDate) = 1997
GROUP BY FORMAT(ShippedDate, 'dddd dd MMMM yyyy')
HAVING SUM(ExtendedPrice) > 100;

-- Listar productos más vendidos
select p.ProductID,
       p.ProductName,
       SUM(od.Quantity) as TotalSold
from [Order Details] od
    join Products p on od.ProductID = p.ProductID
group by p.ProductID, p.ProductName
order by TotalSold desc;

-- Clientes sin pedidos
select c.ContactName,
       c.CustomerID,
       c.CompanyName
from Customers c
         left join Invoices i on c.CustomerID = i.CustomerID
where i.CustomerID is null;
    --# Opción del docente
select * from Invoices
select ProductName,
       ProductID,
       SUM(Quantity) AS TotalQuantity
from Invoices
group by ProductName, ProductID;

-- Inventarios actual de productos
select ProductName, UnitsInStock from Products

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

-- 1h 24 30s Obtener el total de ventas por dia para el año 1997[mostrar los
-- días como: lunes 19 de febrero de 1997], excluyendo los días con ventas
-- totales inferiores a $100:
SELECT FORMAT(ShippedDate, 'dddd dd MMMM yyyy') as    FormattedDate,
       SUM(ExtendedPrice) as TotalSales
FROM Invoices
WHERE YEAR(ShippedDate) = 1997
-- GROUP BY FORMAT(ShippedDate, 'dddd, dd MMMM yyyy')
GROUP BY ShippedDate
HAVING SUM(ExtendedPrice) > 100
ORDER BY ShippedDate asc
;

-- Calcular factura con procedimiento almacenado
CREATE PROCEDURE sp_CalcularFactura (
    @ID_PEDIDO INT,
    @ID_PRODUCTO INT,
    @ID_CLIENTE INT,
    @CANTIDAD DECIMAL(10, 2),
    @DESC INT
)AS SET NOCOUNT ON
BEGIN
    -- INSERTAR PEDIDOS
    INSERT INTO PEDIDOS (ID_CLIENTE, ID_PRODUCTO, CANTIDAD, FECHA_PEDIDO)
    VALUES (@ID_CLIENTE, @ID_PRODUCTO, @CANTIDAD, GETDATE());

-- INSERTAR A FACTURA
    INSERT INTO FACTURAS (IDPEDIDO, SUBTOTAL, DESCUENTO, DESC_TOTAL, TOTAL, FECHA_FACTURA)
    SELECT P.ID,
           SUM(P.CANTIDAD * pr.PRECIO)                                              AS Total,
           @DESC                                                                    AS Descuento,
           SUM(P.CANTIDAD * pr.PRECIO) * @DESC / 100                                AS DescTotal,
           SUM((P.CANTIDAD * pr.PRECIO) - ((P.CANTIDAD * pr.PRECIO) * @DESC / 100)) AS Total,
           GETDATE()                                                                AS FECHA
    FROM PEDIDOS P
             JOIN PRODUCTOS pr ON P.ID_PRODUCTO = pr.ID
    WHERE P.ID = @ID_PEDIDO
    GROUP BY P.ID;

-- MOSTRAR LOS RESULTADOS DE LA FACTURA
    SELECT *
    FROM FACTURAS F
    WHERE F.IDPEDIDO = @ID_PEDIDO;
END;


-- Aplica descuento y añade a la factura
-- calcular venta
create function sp_ventas_calcular_sin_desc(@idpedido int)
    returns int
as
begin
    declare @total decimal(10, 2);
    select @total = sum(p.cantidad * pr.precio)
    from pedidos p
             join productos pr on p.id_producto = pr.id
    where p.id = @idpedido;

    return @total;
end
go

CREATE FUNCTION sp_ventas_con_desc(@idpedido int, @descuento int)
    RETURNS INT
AS
BEGIN
    DECLARE @total DECIMAL(10, 2);

    SELECT @total = SUM(P.CANTIDAD * PR.PRECIO) * (1 - @DESCUENTO / 100.0)
    FROM pedidos p
             JOIN productos pr on p.id_producto = pr.id
    WHERE p.id = @idpedido;

    RETURN @total;
END

CREATE FUNCTION SP_ventas_solo_descuento(@idpedido int, @descuento int)
    RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @total DECIMAL(10, 2);

    SELECT @total = SUM(P.CANTIDAD * PR.PRECIO) * (@descuento / 100.0)
    FROM pedidos p
             JOIN productos pr on p.id_producto = pr.id
    WHERE p.id = @idpedido;

    RETURN @total;
END

-- uso de la función sp_calcular_ventas
select dbo.sp_ventas_calcular_sin_desc(56) as totalventa;
select dbo.sp_ventas_con_desc(56, 10) as totalcondesc;
select dbo.SP_ventas_solo_descuento(56, 10) as totalcondescuento;

-- Procedimiento que calcula las ventas totales, aplica descuento y genera factura, que reune todas las funciones anteriores
CREATE PROCEDURE sp_ventas_totales(
    @idpedido INT,
    @descuento INT
)
AS
BEGIN
    DECLARE @VENTAS DECIMAL(10, 2);
    DECLARE @DESC_APLICADO DECIMAL(10, 2);
    DECLARE @VENTAS_TOTAL DECIMAL(10, 2);

    SELECT @VENTAS = dbo.sp_ventas_calcular_sin_desc(@idpedido);
    SELECT @DESC_APLICADO = dbo.sp_ventas_solo_descuento(@idpedido, @descuento);
    SELECT @VENTAS_TOTAL = dbo.sp_ventas_con_desc(@idpedido, @descuento);

    -- INSERTAR FACTURA
    INSERT INTO facturas (idpedido, subtotal, descuento, desc_total, total, fecha_factura)
    VALUES (@idpedido, @VENTAS, @descuento, @DESC_APLICADO, @VENTAS_TOTAL, getdate());

    -- MOSTRAR FACTURA
    SELECT  C.NOMBRE + ' ' + C.APELLIDO AS CLIENTE,
            PR.NOMBRE,
            P.CANTIDAD,
            F.SUBTOTAL,
            F.DESCUENTO,
            F.DESC_TOTAL,
            F.TOTAL,
            FORMAT(F.FECHA_FACTURA, 'dd/MM/yyyy') AS FECHA_FACTURA
    FROM FACTURAS F
             JOIN PEDIDOS P on F.idpedido = P.id
             JOIN CLIENT C on P.id_cliente = C.id
             JOIN PRODUCTOS PR on P.id_producto = PR.id
    WHERE idpedido = @idpedido
    ;
END

    EXEC sp_ventas_totales @idpedido = 56, @descuento = 10;
    EXEC sp_ventas_totales 56,10;


    -- obtener todos los productos con un precio superior al promedio de precios
SELECT *
FROM PRODUCTOS
WHERE PRECIO > (SELECT AVG(PRECIO) FROM PRODUCTOS);


    -- 4.1 Los clientes que han realizado pedidos en la categoría 2
SELECT * FROM CLIENT
WHERE EXISTS (
    SELECT 1 FROM PEDIDOS P
                      JOIN PRODUCTOS PR ON P.ID_PRODUCTO = PR.ID
    WHERE P.ID_CLIENTE = CLIENT.ID AND PR.CATEGORIA_ID = 2
);