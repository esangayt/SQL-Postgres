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
    SELECT C.NOMBRE + ' ' + C.APELLIDO           AS CLIENTE,
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
    WHERE idpedido = @idpedido;
END
    EXEC sp_ventas_totales @idpedido = 56, @descuento = 10;
    EXEC sp_ventas_totales 56, 10;

    -- ======= CLAUSULAS DE FILTRADOS
-- obtener todos los productos con un precio superior al promedio de precios
SELECT *
FROM PRODUCTOS
WHERE PRECIO > (SELECT AVG(PRECIO) FROM PRODUCTOS);

--     Obtener el nombre de cada producto con al diferencia entre su precio y el precio máximo de todos los productos
SELECT NOMBRE, PRECIO, PRECIO - (SELECT MAX(PRECIO) FROM PRODUCTOS) AS DIFERENCIA_PRECIO
FROM PRODUCTOS;

--     USO DE CROSS JOIN PARA LA OPERACIÓN ANTERIOR
SELECT P.NOMBRE,
       P.PRECIO,
       P.PRECIO - M.MAXP AS DIFERENCIA_PRECIO
FROM PRODUCTOS P
         CROSS JOIN (SELECT MAX(PRECIO) AS MAXP FROM PRODUCTOS) M;

-- Obtener todos los productos juntos con la cantidad total en stock de productos del mismo tipo
SELECT P.ID,
       P.NOMBRE,
       P.PRECIO,
       P.STOCK,
       P.CATEGORIA_ID,
       (select sum(STOCK) FROM PRODUCTOS WHERE CATEGORIA_ID = P.CATEGORIA_ID) AS STOCK_TOTAL
FROM PRODUCTOS P
GROUP BY P.ID, P.NOMBRE, P.PRECIO, P.STOCK, P.CATEGORIA_ID
ORDER BY P.CATEGORIA_ID ;

-- OBTENER LOS PRODUCTOS QUE ESTEN EN LOS IDS 3, 4, 5
select *
from PRODUCTOS
where id in (3, 4, 5);

-- DEVUELVA AL MENOS UNA FILA DE LA TABLA CLIENTE QUE TIENE PEDIDOS
SELECT *
FROM CLIENT C
WHERE EXISTS (SELECT 1 FROM PEDIDOS P WHERE P.ID_CLIENTE = C.ID);


SELECT 1
FROM CLIENT P
WHERE ID = 1

-- Mostrar los productos que al menos uno de ellos sea mayor al precio que la categoria especificada dada
SELECT *
FROM PRODUCTOS
WHERE PRECIO > ANY (SELECT AVG(PRECIO) FROM PRODUCTOS WHERE CATEGORIA_ID = 1);

-- Realice la facturación aplicando el IVA, a cada producto vendido
SELECT (PRECIO * CANTIDAD) * 0.18 IGV
FROM PEDIDOS P
         JOIN PRODUCTOS pr ON P.ID_PRODUCTO = pr.ID
WHERE P.ID = 55

-- CALCULA UNICAMENTE EL IVA
CREATE FUNCTION sp_ventas_calcular_iva(@IDPEDIDO INT, @IVA INT)
    RETURNS decimal(10, 2)
AS
BEGIN
    DECLARE @TOTAL DECIMAL(10, 2)
    SELECT @TOTAL = (PRECIO * CANTIDAD) * (CAST(@IVA AS DECIMAL(5,2)) /100)
    FROM PEDIDOS P
             JOIN PRODUCTOS pr ON P.ID_PRODUCTO = pr.ID
    WHERE P.ID = @IDPEDIDO
    RETURN @TOTAL
END


--  CALCULAR TOTAL A PAGAR
CREATE FUNCTION sp_ventas_calcular_iva_total(@IDPEDIDO INT, @IVA INT)
    RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @TOTAL DECIMAL(10, 2)
    SELECT @TOTAL = (PRECIO * CANTIDAD) * (1 - CAST(@IVA AS DECIMAL(5,2)) /100)
    FROM PEDIDOS P
             JOIN PRODUCTOS pr ON P.ID_PRODUCTO = pr.ID
    WHERE P.ID = @IDPEDIDO
    RETURN @TOTAL
end

CREATE FUNCTION sp_ventas_calcular_iva_totalV2(@IDPEDIDO INT, @IVA INT)
    RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @TOTAL DECIMAL(10, 2)
    SELECT @TOTAL = (PRECIO * CANTIDAD) * (1 + CAST(@IVA AS DECIMAL(5,2)) /100)
    FROM PEDIDOS P
             JOIN PRODUCTOS pr ON P.ID_PRODUCTO = pr.ID
    WHERE P.ID = @IDPEDIDO
    RETURN @TOTAL
end


SELECT DBO.sp_ventas_calcular_iva(55,18)
SELECT DBO.sp_ventas_calcular_iva_total(55,18)

SELECT P.ID,
       SUM(P.CANTIDAD * pr.PRECIO)        AS Total,
       GETDATE()                          AS FECHA,
       SUM(P.CANTIDAD * pr.PRECIO) * 0.18 AS IVA,
       SUM(P.CANTIDAD * pr.PRECIO) * 0.82 AS IVA_TOTAL
FROM PEDIDOS P
         JOIN PRODUCTOS pr ON P.ID_PRODUCTO = pr.ID
WHERE P.ID = 55
GROUP BY P.ID;