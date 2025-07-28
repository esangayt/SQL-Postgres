SELECT LEN(DESCUENTO)
FROM Facturas

SELECT EMAIL,
       LEFT(EMAIL, 5)                                     AS FirstFiveChars,
       RIGHT(EMAIL, 5)                                    AS LastFiveChars,
       SUBSTRING(EMAIL, 6, 5)                             AS MiddleFiveChars,
       LOWER(EMAIL)                                       AS LowerEmail,
       UPPER(EMAIL)                                       AS UpperEmail,
       CONCAT(LEFT(EMAIL, 5), ' ', RIGHT(EMAIL, 5))       AS ConcatenatedEmail,
       REPLACE(REPLACE(EMAIL, '@', '[at]'), '.', '[dot]') AS EmailWithReplacements
FROM CLIENT

-- FUNCIONES DE FECHAS
SELECT FECHA_FACTURA,
       FORMAT(GETDATE(), 'h:mm tt')   AS FormattedDate,
       GETDATE()                      AS CurrentDate,
       YEAR(FECHA_FACTURA)            AS Year,
       MONTH(FECHA_FACTURA)           AS Month,
       DAY(FECHA_FACTURA)             AS Day,
       DATEPART(YEAR, FECHA_FACTURA)  AS DatePartYear,
       DATEPART(MONTH, FECHA_FACTURA) AS DatePartMonth,
       DATEPART(DAY, FECHA_FACTURA)   AS DatePartDay,
       DATENAME(YEAR, FECHA_FACTURA)  AS DateNameYear,
       DATENAME(MONTH, FECHA_FACTURA) AS DateNameMonth,
       DATENAME(DAY, FECHA_FACTURA)   AS DateNameDay
FROM Facturas;

SELECT FECHA_PEDIDO,
       DATEADD(YEAR, 1, FECHA_PEDIDO)           AS DateAddYear,
       DATEADD(MONTH, 1, FECHA_PEDIDO)          AS DateAddMonth,
       DATEADD(DAY, 1, FECHA_PEDIDO)            AS DateAddDay,
       DATEDIFF(YEAR, FECHA_PEDIDO, GETDATE())  AS DateDiffYear,
       DATEDIFF(MONTH, FECHA_PEDIDO, GETDATE()) AS DateDiffMonth,
       DATEDIFF(DAY, FECHA_PEDIDO, GETDATE())   AS DateDiffDay
FROM PEDIDOS

-- DIFERENCIA ENTRE FECHAS PEDIDO Y FACTURA
SELECT DATEDIFF(DAY, P.FECHA_PEDIDO, F.FECHA_FACTURA) AS DaysBetween
FROM PEDIDOS P
         JOIN Facturas F ON P.ID = F.IDPEDIDO

-- REPORTES
SELECT DAY(FECHA_FACTURA)            AS Day,
       YEAR(FECHA_FACTURA)           AS Year,
       MONTH(FECHA_FACTURA)          AS Month,
       DATEPART(WEEK, FECHA_FACTURA) AS Week
FROM Facturas

-- FORMAT
SELECT FORMAT(FECHA_FACTURA, 'dd/MM/yyyy') AS FormattedDate,
       FORMAT(FECHA_FACTURA, 'MMMM yyyy')  AS MonthYear,
       FORMAT(FECHA_FACTURA, 'dddd')       AS DayOfWeek
FROM Facturas;

-- add facturas table client
ALTER TABLE Facturas
    ADD IDEMPLEADO INT NULL;

-- add foreign key
ALTER TABLE Facturas
    ADD CONSTRAINT FK_Facturas_Empleados
        FOREIGN KEY (IDEMPLEADO) REFERENCES EMPLEADO (ID);

ALTER TABLE PEDIDOS
    ADD IDEMPLEADO INT NULL;

-- add foreign key
ALTER TABLE PEDIDOS
    ADD CONsTRAINT FK_Pedidos_Empleados
        FOREIGN KEY (IDEMPLEADO) REFERENCES EMPLEADO (ID);


DECLARE @ID_PEDIDO INT = 55;
DECLARE @IVA DECIMAL(10, 2) = 10;

INSERT INTO FACTURAS(IDPEDIDO, SUBTOTAL, DESCUENTO, DESC_TOTAL, TOTAL, FECHA_FACTURA, IDEMPLEADO)
SELECT P.ID,
       SUM(P.CANTIDAD * pr.PRECIO)                    AS Total,
       @IVA                                           AS IVA,
       SUM(P.CANTIDAD * pr.PRECIO) * (@IVA / 100)     AS IVA_TOTAL,
       SUM(P.CANTIDAD * pr.PRECIO) * (1 + @IVA / 100) AS TOTAL_CON_IVA,
--        +: para IGV, -: Para descuento
--        SUM(P.CANTIDAD * pr.PRECIO) * (1+@IVA/100) AS TOTAL_CON_IVA,
       GETDATE()                                      AS FECHA,
       E.ID                                           AS IDEMPLEADO
FROM PEDIDOS P
         JOIN PRODUCTOS pr ON P.ID_PRODUCTO = pr.ID
         JOIN EMPLEADO E ON P.IDEMPLEADO = E.ID
WHERE P.ID = @ID_PEDIDO
GROUP BY P.ID, E.ID;

SELECT F.IDPEDIDO,
       C.NOMBRE + ' ' + C.APELLIDO                 AS CLIENTE,
       E.NOMBRE + ' ' + E.APELLIDO                 AS EMPLEADO,
       P.CANTIDAD,
       CONCAT('S/', ' ', F.SUBTOTAL)               AS SUBTOTAL,
       CONCAT('S/', ' ', F.DESCUENTO)              AS DESCUENTO,
       CONCAT('S/', ' ', F.DESC_TOTAL)             AS DESC_TOTAL,
       CONCAT('S/', ' ', F.TOTAL)                  AS TOTAL,
       FORMAT(F.FECHA_FACTURA, 'dddd, dd/MM/yyyy') AS FECHA_FACTURA
FROM FACTURAS F
         JOIN PEDIDOS P on F.idpedido = P.id
         JOIN CLIENT C on P.id_cliente = C.id
         JOIN EMPLEADO E ON F.IDEMPLEADO = E.ID

