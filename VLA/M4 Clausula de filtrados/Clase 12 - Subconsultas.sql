-- ======== SUBCONSULTAS: Subconsultas en SQL son consultas anidadas dentro de otra consulta =======
-- CATEGORIAS
--1.  Obtener productos con un precio superior a una categoria específica
-- Palabras sencillas: Dame todos los productos cuyo precio sea mayor que el de al menos un producto de la categoría 1.
SELECT *
FROM PRODUCTOS P
WHERE EXISTS (SELECT 1 FROM PRODUCTOS C WHERE C.CATEGORIA_ID = 1 AND P.PRECIO > C.PRECIO);
-- Subconsulta: De los productos con la categoria 1, toma los que tenga un precio menor al precio de P
-- La condición EXISTS devuelve TRUE si la subconsulta interna devuelve al menos una fila

-- PEDIDOS
-- 2. Clientes con más de un pedido
SELECT *
FROM CLIENT
WHERE ID IN (SELECT ID_CLIENTE FROM PEDIDOS GROUP BY ID_CLIENTE HAVING COUNT(*) > 2);
-- La subconsulta en any solo debe tener una columna definida
-- Si el valor cumple la condición con al menos un valor devuelto por la subconsulta

SELECT ID_CLIENTE, COUNT(*) TOTAL
FROM PEDIDOS
GROUP BY ID_CLIENTE
HAVING COUNT(*) > 2;
-- Having no necesita estar definido en el select, debido que se filtra luego del group by


-- 3. Todos los pedidos junto con el total de productos en cada pedido
SELECT P.ID_PRODUCTO, COUNT(*) AS TOTAL_PRODUCTOS
FROM PEDIDOS P
         JOIN FACTURA F ON P.ID = F.ID_PEDIDOS
GROUP BY P.ID_PRODUCTO

SELECT P.ID_PRODUCTO,
       P.FECHA_PEDIDO,
       (SELECT COUNT(*) FROM Factura WHERE ID_PEDIDOS = P.ID) TOTAL_PRODUCTOS
FROM PEDIDOS P;


-- 3.1 Clientes con el total de productos comprados
WITH Totales AS (SELECT ID_CLIENTE, SUM(CANTIDAD) AS TOTAL_PRODUCTOS
                 FROM PEDIDOS
                 GROUP BY ID_CLIENTE)
-- WITH es una expresión de tabla común (CTE) que permite definir una consulta temporal que se puede referenciar dentro de la consulta principal.

SELECT *
FROM Totales T
         JOIN CLIENT C on T.ID_CLIENTE = C.ID
WHERE T.TOTAL_PRODUCTOS > 2;

-- 4 Los pedidos realizados por clientes que también han realizado pedidos en la categoría 2
SELECT *
FROM PEDIDOS P
WHERE EXISTS(SELECT 1
             FROM PEDIDOS P2
                      JOIN PRODUCTOS PR ON P2.ID_PRODUCTO = PR.ID
             WHERE P2.ID_CLIENTE = P.ID_CLIENTE
               AND PR.CATEGORIA_ID = 2)
-- Para cada pedido P (cualquier producto), revisa si ese cliente tiene al menos un pedido con categoría 2 (en cualquier otro pedido).
-- Si lo tiene, entonces se devuelven todos los pedidos de ese cliente, no solo los de la categoría 2.
-- Entiendo: Obtienes todos pedidos del cliente si este ha comprado al menos un producto de la categoría 2.

-- 4.1 Los clientes que han realizado pedidos en la categoría 2
SELECT *
FROM CLIENT
WHERE EXISTS (SELECT 1
              FROM PEDIDOS P
                       JOIN PRODUCTOS PR ON P.ID_PRODUCTO = PR.ID
              WHERE P.ID_CLIENTE = CLIENT.ID
                AND PR.CATEGORIA_ID = 2);
-- CLIENTE 1,
-- P.ID_CLIENTE = 1 AND PR.CATEGORIA_ID = 2
-- LA SUBCONSULTA BUSCA PEDIDOS PARA EL CLIENTE 1 Y ADICIONAL QUE TENGAN ESA CATEGORIA
-- DEVUELVE UNA COLUMNA => ESE CLIENTE SE INCLUYE EN EL RESULTADO

-- CLIENTE 2
-- P.ID_CLIENTE = 2 AND PR.CATEGORIA_ID = 2
-- NO DEVUELVE UNA COLUMNA => ESE CLIENTE NO SE INCLUYE EN EL RESULTADO

-- 5. Todas las facturas con descuento aplicado
SELECT *
FROM Facturas
WHERE DESCUENTO > 10

-- 6 OBTENER LOS DETALLES DE FACTURAS CON EL NOMBRE DEL CLIENTE
SELECT F.*, C.NOMBRE
FROM Facturas F
         JOIN PEDIDOS P ON F.IDPEDIDO = P.ID
         JOIN CLIENT C ON P.ID_CLIENTE = C.ID;

-- ============================== EJERCICIOS DE CLASE ==============================

--OBTENER EL TOTAL DE VENTAS
SELECT sum(TOTAL)
FROM Facturas

-- OBTENER EL PROMEDIO DE VENTAS POR CLIENTE
SELECT CLIENT.ID, AVG(TOTAL)
FROM Facturas
         JOIN PEDIDOS ON Facturas.IDPEDIDO = PEDIDOS.ID
         JOIN CLIENT ON PEDIDOS.ID_CLIENTE = CLIENT.ID
GROUP BY CLIENT.ID

-- OBTENER LAS FACTURAS CON UN TOTAL MAYOR A 80
SELECT *
FROM Facturas
WHERE total > 80

-- OBTENER EL NUMERO DE FACTURAS POR MES Y AÑO, ORDENADO POR AÑO Y MES
SELECT YEAR(FECHA_FACTURA) AÑO, MONTH(FECHA_FACTURA) MES, COUNT(*) TOTAL
FROM Facturas
         JOIN PEDIDOS on Facturas.IDPEDIDO = PEDIDOS.ID
         JOIN CLIENT on PEDIDOS.ID_CLIENTE = CLIENT.ID
GROUP BY YEAR(FECHA_FACTURA), MONTH(FECHA_FACTURA)
ORDER BY MES DESC, AÑO ASC

-- OBTENER EL NUMERO TOTAL DE FACTURAS POR CLIENTE, PERO SOLO PARA AQUELLOS QUE TIENEN MÁS DE 2 FACTURAS
SELECT CLIENT.ID, COUNT(*) CANTIDAD
FROM Facturas
         JOIN PEDIDOS ON Facturas.IDPEDIDO = PEDIDOS.ID
         JOIN CLIENT ON PEDIDOS.ID_CLIENTE = CLIENT.ID
GROUP BY CLIENT.ID
HAVING COUNT(*) > 2