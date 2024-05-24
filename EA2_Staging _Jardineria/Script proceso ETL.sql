-- Crear la base de datos jardineriaDIM
CREATE DATABASE jardineriaDIM;
GO

-- Usar la base de datos jardineriaDIM
USE jardineriaDIM;
GO

-- Crear la tabla DimTiempo
CREATE TABLE DimTiempo (
    ID_tiempo INT PRIMARY KEY,
    fecha_pedido DATE NOT NULL,
    anio INT NOT NULL,
    mes INT NOT NULL,
    dia INT NOT NULL
);
GO

-- Crear la tabla DimProducto
CREATE TABLE DimProducto (
    ID_producto INT PRIMARY KEY,
    nombre VARCHAR(70) NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    proveedor VARCHAR(50) DEFAULT NULL
);
GO

-- Crear la tabla DimCliente
CREATE TABLE DimCliente (
    ID_cliente INT PRIMARY KEY,
    nombre_cliente VARCHAR(50) NOT NULL,
    ciudad VARCHAR(50) NOT NULL,
    pais VARCHAR(50) DEFAULT NULL
);
GO

-- Crear la tabla DimOficina
CREATE TABLE DimOficina (
    ID_oficina INT PRIMARY KEY,
    Descripcion VARCHAR(10) NOT NULL,
    ciudad VARCHAR(30) NOT NULL,
    pais VARCHAR(50) NOT NULL
);
GO

-- Crear la tabla VentaHechos
CREATE TABLE VentaHechos (
    ID_venta INT PRIMARY KEY,
    ID_tiempo INT NOT NULL,
    ID_cliente INT NOT NULL,
    ID_producto INT NOT NULL,
    ID_oficina INT NOT NULL,
    cantidad_vendida INT NOT NULL,
    monto_total DECIMAL(15,2) NOT NULL,
    FOREIGN KEY (ID_tiempo) REFERENCES DimTiempo(ID_tiempo),
    FOREIGN KEY (ID_cliente) REFERENCES DimCliente(ID_cliente),
    FOREIGN KEY (ID_producto) REFERENCES DimProducto(ID_producto),
    FOREIGN KEY (ID_oficina) REFERENCES DimOficina(ID_oficina)
);
GO

----------------------------------------------------
-- script para obtener los datos necesarios para el DimOficina
SELECT 
    ID_oficina,
    Descripcion,
    ciudad,
    pais
FROM oficina;

----------------------------------------------------
-- script para obtener los datos necesarios para el DimTiempo
SELECT 
    p.ID_pedido,
    p.fecha_pedido,
    YEAR(p.fecha_pedido) AS anio,
    MONTH(p.fecha_pedido) AS mes,
    DAY(p.fecha_pedido) AS dia
FROM pedido p;

---------------------------------------------------
-- script para obtener los datos necesarios para el DimProducto
SELECT ID_producto, nombre,
    (SELECT Desc_Categoria
    FROM Categoria_producto
    WHERE (Id_Categoria = p.Categoria)) AS categoria, 
	proveedor
FROM producto AS p

---------------------------------------------------
-- script para obtener los datos necesarios para el DimCliente
SELECT 
    ID_cliente,
    nombre_cliente,
    ciudad,
    pais
FROM cliente;

---------------------------------------------------
-- script para obtener los datos necesarios para VentaHechos
SELECT 
    dp.ID_detalle_pedido,
    p.ID_pedido,
    c.ID_cliente,
    dp.ID_producto,
    o.ID_oficina,
    dp.cantidad,
    dp.precio_unidad * dp.cantidad AS monto_total
FROM detalle_pedido dp
JOIN pedido p ON dp.ID_pedido = p.ID_pedido
JOIN cliente c ON p.ID_cliente = c.ID_cliente
JOIN producto pr ON dp.ID_producto = pr.ID_producto
JOIN empleado e ON c.ID_empleado_rep_ventas = e.ID_empleado
JOIN oficina o ON e.ID_oficina = o.ID_oficina;
