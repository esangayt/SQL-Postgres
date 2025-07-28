-- ============================================ EXAMEN ============================================
-- 1. Insertar 5 nuevos productos con su categoría. (2pts)
insert into CATEGORIAS (NOMBRE) values ('Bebidas');
insert into CATEGORIAS (NOMBRE) values ('Lácteos');
insert into CATEGORIAS (NOMBRE) VALUES ('Carnes');

INSERT INTO PRODUCTOS (NOMBRE, PRECIO, STOCK, CATEGORIA_ID)
VALUES ('Cerveza', 1.50, 100, (SELECT ID FROM CATEGORIAS WHERE NOMBRE = 'Bebidas')),
       ('Leche', 0.80, 200, (SELECT ID FROM CATEGORIAS WHERE NOMBRE = 'Lácteos')),
       ('Carne Molida', 3.00, 150, (SELECT ID FROM CATEGORIAS WHERE NOMBRE = 'Carnes')),
       ('Yogur', 1.20, 120, (SELECT ID FROM CATEGORIAS WHERE NOMBRE = 'Lácteos')),
       ('Vino Tinto', 5.00, 80, (SELECT ID FROM CATEGORIAS WHERE NOMBRE = 'Bebidas'));

-- 2. Actualizar los correos de los clientes de al menOS 2 de ellos
UPDATE CLIENT
SET EMAIL = 'nevo@correo.gmail'
WHERE ID IN (1, 2);
-- 3. Realice una Venta y aplique el IVA del 5% de la compra. (2pts)
DECLARE @ID_PEDIDO INT = 55;
DECLARE @IVA INT = 18;

INSERT INTO FACTURAS(IDPEDIDO, SUBTOTAL, DESCUENTO, DESC_TOTAL, TOTAL, FECHA_FACTURA)
SELECT P.ID,
       SUM(P.CANTIDAD * pr.PRECIO)        AS Total,
       @IVA AS IVA,
       SUM(P.CANTIDAD * pr.PRECIO) * 0.18 AS IVA_TOTAL,
       SUM(P.CANTIDAD * pr.PRECIO) * 1.18 AS TOTAL_CON_IVA,
       GETDATE()                          AS FECHA
FROM PEDIDOS P
         JOIN PRODUCTOS pr ON P.ID_PRODUCTO = pr.ID
WHERE P.ID = @ID_PEDIDO
GROUP BY P.ID;

-- 4. Informes mensuales de ventas en el Almacén. (2pts)
SELECT MONTH(FECHA_FACTURA) MONTH,
       YEAR(FECHA_FACTURA) YEAR,
       SUM(TOTAL)
FROM Facturas
GROUP BY MONTH(FECHA_FACTURA), YEAR(FECHA_FACTURA)

-- 5. Mostrar los productos más vendidos(2pts)
SELECT PR.NOMBRE,
-- SELECT TOP 2 PR.NOMBRE,
       SUM(P.CANTIDAD) AS TOTAL_VENDIDO
FROM PEDIDOS P
JOIN PRODUCTOS PR ON P.ID_PRODUCTO = PR.ID
GROUP BY  PR.NOMBRE, PR.ID

SELECT PR.NOMBRE,
       SUM(P.CANTIDAD) AS TOTAL_VENDIDO
FROM Facturas
JOIN PEDIDOS P ON Facturas.IDPEDIDO = P.ID
JOIN PRODUCTOS PR ON P.ID_PRODUCTO = PR.ID
GROUP BY PR.NOMBRE, PR.ID