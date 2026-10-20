
USE tienda_maquillaje;

-- Categorias
INSERT INTO categorias (id_categoria, nombre) VALUES
(1, 'Cosméticos'),
(2, 'Cuidado de la Piel'),
(3, 'Perfumes'),
(4, 'Accesorios');

-- Areas
INSERT INTO areas (id_area, nombre) VALUES
(1, 'Venta'),
(2, 'Bodega'),
(3, 'Administración');

-- Empleados
INSERT INTO empleados (nombre_completo, puesto, fecha_contratacion, id_area) VALUES
('Ana Gómez', 'Asesora de Ventas', '2023-01-15', 1),
('Carlos López', 'Encargado de Bodega', '2022-05-10', 2),
('María Rodríguez', 'Gerente General', '2021-03-01', 3),
('Laura Martínez', 'Vendedora', '2025-08-20', 1);

-- Clientes
INSERT INTO clientes (nombre_completo, correo_electronico, direccion, telefono) VALUES
('Sofia Fernández', 'sofia@gmail.com', 'Calle 10 # 5-20', '5556-1010'),
('Lucía Morales', 'lucia@gmail.com', 'Av. Reforma 12-45', '5554-2020'),
('Mateo Ruiz', 'mateo@gmail.com', 'Zona 10 Edificio A', '5552-3030');

-- Proveedores
INSERT INTO proveedores (nombre_empresa, nombre_contacto, telefono, direccion) VALUES
('Beauty Supply Co.', 'Roberto Pérez', '5555-9090', 'Av. Industrial 45'),
('Glow Skin Lab', 'Elena Torres', '5555-8080', 'Parque Tecnológico B');

-- PRODUCTOS
------------------------------------------------------------------------------------------------
-- 1. Cosmético
INSERT INTO productos (id_producto, nombre, descripcion, precio, stock, id_categoria) 
VALUES (1, 'Labial Mate Rojo', 'Labial de larga duración color rojo intenso', 15.50, 8, 1);
INSERT INTO caracteristicas (id_producto, tipo, tono_color, fecha_expiracion) 
VALUES (1, 'Labial', 'Rojo Pasión', '2026-12-31');

-- 2. Cosmético
INSERT INTO productos (id_producto, nombre, descripcion, precio, stock, id_categoria) 
VALUES (2, 'Base Líquida Cobertura Total', 'Base de alta cobertura acabado natural', 28.00, 25, 1);
INSERT INTO caracteristicas (id_producto, tipo, tono_color, fecha_expiracion) 
VALUES (2, 'Base', 'Beige Natural', '2027-05-15');

-- 3. Cuidado de la piel 
INSERT INTO productos (id_producto, nombre, descripcion, precio, stock, id_categoria) 
VALUES (3, 'Sérum Ácido Hialurónico', 'Hidratación profunda para el rostro', 32.00, 4, 2);
INSERT INTO caracteristicas (id_producto, tipo, componentes, fecha_expiracion) 
VALUES (3, 'Seca', 'Ácido Hialurónico, Vitamina B5', '2026-09-30');

-- 4. Perfume
INSERT INTO productos (id_producto, nombre, descripcion, precio, stock, id_categoria) 
VALUES (4, 'Eau de Parfum Floral', 'Fragancia dulce con notas de jazmín', 65.00, 15, 3);
INSERT INTO caracteristicas (id_producto, aroma, tamano) 
VALUES (4, 'Floral / Dulce', '100ml');

-- 5. Accesorio
INSERT INTO productos (id_producto, nombre, descripcion, precio, stock, id_categoria) 
VALUES (5, 'Set de Brochas Sintéticas', 'Set de 10 brochas profesionales', 22.50, 3, 4);
INSERT INTO caracteristicas (id_producto, material, tamano) 
VALUES (5, 'Pelo sintético suave', 'Estándar');

--------------------------------------------------------------------------------------------------------------------------------------

-- Ventas
INSERT INTO ventas (id_venta, fecha_venta, id_cliente, id_empleado) VALUES
(1, '2026-10-01 10:30:00', 1, 1),
(2, '2026-10-15 14:20:00', 2, 1),
(3, '2026-10-20 11:00:00', 1, 4);

-- Detalles de Ventas
INSERT INTO detalles_venta (id_venta, id_producto, cantidad, precio_unitario) VALUES
(1, 1, 2, 15.50), -- 2 labiales
(1, 3, 1, 32.00), -- 1 sérum
(2, 4, 1, 65.00), -- 1 perfume
(3, 1, 1, 15.50); -- 1 labial

-- Ordenes de Compra a Proveedores
INSERT INTO ordenes_compra (id_orden, id_proveedor, fecha_orden) VALUES
(1, 1, '2025-11-10'),
(2, 2, '2026-03-15');

INSERT INTO detalles_orden_compra (id_orden, id_producto, cantidad_solicitada, cantidad_recibida) VALUES
(1, 1, 50, 50),
(1, 2, 30, 30),
(2, 3, 20, 20);