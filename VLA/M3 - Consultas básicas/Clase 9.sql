-- Declaración de prodedimientos almacenados
CREATE PROCEDURE sp_Nombre_Procedimiento (parametro1 INT, parametro2 INT)
AS SET NOCOUNT ON
BEGIN
--     INSTRUCCIONES SQL AQUÍ

END;


CREATE PROCEDURE sp_CrearClientes (
    @nombre varchar(50),
    @apellidos varchar(50),
    @email varchar(100),
    @fechaNacimiento date
)
AS SET NOCOUNT ON
BEGIN
    --     INSTRUCCIONES SQL AQUÍ
    INSERT INTO CLIENT (nombre, apellido,email, FECHA_REGISTRO)
    VALUES (@nombre, @apellidos,@email, @fechaNacimiento);
END;

--     Ejecución del procedimiento almacenado
EXEC sp_CrearClientes
    @nombre = 'Juan',
    @apellidos = 'Pérez',
    @email = 'juanp@gmail.com',
    @fechaNacimiento = '1990-01-01';
--     Ejecución del procedimiento almacenado

-- actualizar un cliente
CREATE PROCEDURE sp_ActualizarCliente (
    @clienteID INT,
    @nombre VARCHAR(50),
    @apellidos VARCHAR(50),
    @email VARCHAR(100),
    @fechaNacimiento DATE
)
AS SET NOCOUNT ON
BEGIN
    --     INSTRUCCIONES SQL AQUÍ
    UPDATE CLIENT
    SET nombre = @nombre,
        apellido = @apellidos,
        email = @email,
        FECHA_REGISTRO = @fechaNacimiento
    WHERE ID = @clienteID;
END;

--     Ejecución del procedimiento almacenado
EXEC sp_ActualizarCliente
    @clienteID = 6,
    @nombre = 'Juancito',
    @apellidos = 'Pérezito',
    @email = 'juancito@perezito.com',
    @fechaNacimiento = '1990-01-01';

-- Procedimiento para eliminar un cliente
CREATE PROCEDURE sp_EliminarCliente (
    @clienteID INT
)
AS SET NOCOUNT ON
BEGIN
    --     INSTRUCCIONES SQL AQUÍ
    DELETE FROM CLIENT
    WHERE ID = @clienteID;
END;

--     Ejecución del procedimiento almacenado
EXEC sp_EliminarCliente @clienteID = 6;


-- Procedimiento para buscar un cliente por nombre
CREATE PROCEDURE sp_BuscarClientePorNombre (
    @nombre VARCHAR(50)
)
AS SET NOCOUNT ON
BEGIN
    --     INSTRUCCIONES SQL AQUÍ
    SELECT *
    FROM CLIENT
    WHERE nombre LIKE '%' + @nombre + '%';
END;

exec sp_BuscarClientePorNombre @nombre = 'jan';

--  2 15 30 Crea procedimiento almacenado para calcular la factura de un cliente
--
--
--
--
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

-- Ejecución del procedimiento almacenado para calcular la factura
DECLARE @ID_PEDIDO INT = 3;
DECLARE @ID_PRODUCTO INT = 1;
DECLARE @ID_CLIENTE INT =1;
DECLARE @CANTIDAD DECIMAL(10,2) = 3;
DECLARE @DESC INT = 90;
-- Ejecutar el procedimiento almacenado
EXEC sp_CalcularFactura
    @ID_PEDIDO = @ID_PEDIDO,
    @ID_PRODUCTO = @ID_PRODUCTO,
    @ID_CLIENTE = @ID_CLIENTE,
    @CANTIDAD = @CANTIDAD,
    @DESC = @DESC;

--     Clientes que no han realizado pedidos
select * from CLIENT
left join PEDIDOS p on CLIENT.ID = p.ID_CLIENTE
where p.ID_CLIENTE is null;

-- Clientes que han realizado pedidos
select * from PRODUCTOS
left join PEDIDOS p on PRODUCTOS.ID = p.ID_PRODUCTO
left join CLIENT c on p.ID_CLIENTE = c.ID
where p.ID is not null;