-- Crear la base de datos si no existe
CREATE TABLE CLIENT (
    ID             INT PRIMARY KEY IDENTITY (1,1),
    NOMBRE         NVARCHAR(50)  NOT NULL,
    APELLIDO       NVARCHAR(50)  NOT NULL,
    EMAIL          NVARCHAR(100) NOT NULL UNIQUE,
    FECHA_REGISTRO DATETIME DEFAULT GETDATE()
);




-- Insertar datos en la tabla CLIENT
INSERT INTO CLIENT (NOMBRE, APELLIDO, EMAIL) VALUES
('Jane', 'Smith', 'JaneSmith@gmail.com'),
('Alice', 'Johnson', 'alicejohnson@gmail.com'),
('Bob', 'Brown', 'BobBrown@gmail.com')
;

SELECT * FROM CLIENT;

-- Agregar una columna TELEFONO a la tabla CLIENT
ALTER TABLE CLIENT ADD TELEFONO NVARCHAR(20);

-- Actualizar la columna TELEFONO para el registro con ID = 1
UPDATE CLIENT SET TELEFONO = '1234567890' WHERE ID = 1;


-- Eliminar un registro de la tabla CLIENT
DELETE FROM CLIENT WHERE ID = 2;

-- crear categoria productos
CREATE TABLE CATEGORIAS (
    ID INT IDENTITY (1,1) PRIMARY KEY,
    NOMBRE NVARCHAR(100) NOT NULL
);
C:/Users/Delta2/Documents/Proyectos/sql/VLA/Clase 5.sql:37
-- insertar datos en la tabla categorias
INSERT INTO CATEGORIAS (NOMBRE) VALUES
('Electronics'),
('Books'),
('Clothing'),
('Home Appliances');

-- crear tabla productos
CREATE TABLE PRODUCTOS (
    ID INT IDENTITY (1,1) PRIMARY KEY,
    CATEGORIA_ID INT NOT NULL,
    NOMBRE NVARCHAR(100) NOT NULL,
    PRECIO DECIMAL(10, 2) NOT NULL,
    STOCK INT NOT NULL

    FOREIGN KEY (CATEGORIA_ID) REFERENCES CATEGORIAS(ID),
);

-- INSERTAR DATOS EN LA TABLA PRODUCTOS
INSERT INTO PRODUCTOS (CATEGORIA_ID, NOMBRE, PRECIO, STOCK) VALUES
(1, 'Smartphone', 299.99, 50),
(2, 'Programming Book', 29.99, 100),
(3, 'T-Shirt', 19.99, 200),
(4, 'Microwave Oven', 89.99, 30);

-- crear tabla factura
CREATE TABLE FACTURA
(
    ID            INT IDENTITY (1,1) PRIMARY KEY,
    ID_PEDIDOS    INT,
    FECHA_FACTURA INT,
    TOTAL         DECIMAL(10, 2)
)

-- CREAR TABla PEDIDOS
CREATE TABLE PEDIDOS
(
    ID          INT IDENTITY (1,1) PRIMARY KEY,
    ID_CLIENTE  INT NOT NULL,
    ID_PRODUCTO INT NOT NULL,
    FECHA_PEDIDO DATETIME DEFAULT GETDATE(),
    CANTIDAD       DECIMAL(10, 2) NOT NULL,

    FOREIGN KEY (ID_CLIENTE) REFERENCES CLIENT(ID)
);

-- eliminar fecha de la factura
    ALTER TABLE FACTURA DROP COLUMN FECHA_FACTURA;
-- añadir columna fecha a la factura
    ALTER TABLE FACTURA ADD FECHA_FACTURA DATETIME DEFAULT GETDATE();
-- insertar datos en la tabla factura
INSERT INTO FACTURA (ID_PEDIDOS, TOTAL) VALUES
(1, 319.98),
(2, 29.99),
(3, 19.99);
-- insertar datos en la tabla pedidos
INSERT INTO PEDIDOS (ID_CLIENTE, ID_PRODUCTO, CANTIDAD) VALUES
(1, 1, 1), -- Cliente 1 compra 1 Smartphone
(3, 2, 2), -- Cliente 2 compra 2 Programming Books
(4, 3, 3); -- Cliente 3 compra 3 T-Shirts

-- Añadir relación entre PEDIDOS y PRODUCTOS
ALTER TABLE PEDIDOS ADD CONSTRAINT FK_PEDIDOS_PRODUCTOS FOREIGN KEY (ID_PRODUCTO) REFERENCES PRODUCTOS(ID);
-- Añadir relación entre factura y pedidos
ALTER TABLE FACTURA ADD CONSTRAINT FK_FACTURA_PEDIDOS FOREIGN KEY (ID_PEDIDOS) REFERENCES PEDIDOS(ID);