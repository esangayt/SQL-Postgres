select ROUND(12.3, 0)   as RoundedValue,
       CEILING(12.3456) as CeilValue,
       FLOOR(12.3456)   as FloorValue,
       ABS(-12.3456)    as AbsoluteValue,
       POWER(2, 3)      as PowerValue,
       SQRT(16)         as SquareRootValue,
       RAND()           as RandomValue;

-- HERAMIENTA PARA CREAR DIAGRAMAS ENTIDAD RELACIÓN
-- https://www.erdplus.com/

-- EJEMPLOS BÁSICOS DE AGREGACIÓN DE DATOS
SELECT SUM(TOTAL),
       AVG(TOTAL)                     as AverageTotal,
       DATENAME(MONTH, FECHA_FACTURA) as Month,
       YEAR(FECHA_FACTURA)            as Year
FROM Facturas
GROUP BY DATENAME(MONTH, FECHA_FACTURA), YEAR(FECHA_FACTURA)

SELECT SUM(TOTAL),
       AVG(TOTAL)                                              as AverageTotal,
       CASE
           WHEN MONTH(FECHA_FACTURA) = 1 THEN 'Enero'
           WHEN MONTH(FECHA_FACTURA) = 2 THEN 'Febrero'
           WHEN MONTH(FECHA_FACTURA) = 3 THEN 'Marzo'
           WHEN MONTH(FECHA_FACTURA) = 4 THEN 'Abril'
           WHEN MONTH(FECHA_FACTURA) = 5 THEN 'Mayo'
           WHEN MONTH(FECHA_FACTURA) = 6 THEN 'Junio'
           WHEN MONTH(FECHA_FACTURA) = 7 THEN 'Julio'
           WHEN MONTH(FECHA_FACTURA) = 8 THEN 'Agosto'
           WHEN MONTH(FECHA_FACTURA) = 9 THEN 'Septiembre'
           WHEN MONTH(FECHA_FACTURA) = 10 THEN 'Octubre'
           WHEN MONTH(FECHA_FACTURA) = 11 THEN 'Noviembre'
           WHEN MONTH(FECHA_FACTURA) = 12 THEN 'Diciembre' END as MonthName,
       YEAR(FECHA_FACTURA)                                     as Year
FROM Facturas
GROUP BY MONTH(FECHA_FACTURA), YEAR(FECHA_FACTURA)

-- COUNT
SELECT COUNT(*) TOTAL FROM CLIENT

-- MAX MIN
SELECT MAX(TOTAL) AS MaxTotal,
       MIN(TOTAL) AS MinTotal
FROM Facturas;

SELECT MAX(PRECIO) AS MaxTotal,
       MIN(PRECIO) AS MinTotal
FROM PRODUCTOS;

-- POWER
SELECT POWER(PRECIO, 2) AS PrecioAlCuadrado,
        PRECIO
FROM PRODUCTOS


CREATE TABLE CATEGORIA_EMPLEADO (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    CARGO VARCHAR(50) NOT NULL,
    SALARIO DECIMAL(10, 2) NOT NULL,
);

INSERT INTO CATEGORIA_EMPLEADO (CARGO, SALARIO)
VALUES ('Gerente', 5000.00),
       ('Supervisor', 3000.00),
       ('Operario', 1500.00),
       ('Administrativo', 2000.00);

CREATE TABLE EMPLEADO (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    NOMBRE VARCHAR(50) NOT NULL,
    APELLIDO VARCHAR(50) NOT NULL,
    CATEGORIA_ID INT,
    FOREIGN KEY (CATEGORIA_ID) REFERENCES CATEGORIA_EMPLEADO(ID)
);

INSERT INTO EMPLEADO (NOMBRE, APELLIDO, CATEGORIA_ID)
VALUES ('Juan', 'Pérez', 1),
       ('María', 'Gómez', 2),
       ('Carlos', 'López', 3),
       ('Ana', 'Martínez', 4);