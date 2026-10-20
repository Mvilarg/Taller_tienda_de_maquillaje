DELIMITER $$

-- 1. Listar productos de cosméticos de un tipo específico 
CREATE PROCEDURE listar_cosmeticos_por_tipo(IN p_tipo VARCHAR(50))
BEGIN
    SELECT p.id_producto, p.nombre, p.descripcion, p.precio, p.stock, c.tipo, c.tono_color, c.fecha_expiracion
    FROM productos p
    INNER JOIN caracteristicas c ON p.id_producto = c.id_producto
   
    WHERE p.id_categoria = 1 AND LOWER(c.tipo) = LOWER(p_tipo);
END $$

DELIMITER ;

CALL listar_cosmeticos_por_tipo('labial');

-- 2. Obtener productos en una categoria cuyo stock sea inferior a un valor dado
DELIMITER $$

CREATE PROCEDURE productos_bajo_stock(IN p_id_categoria INT, IN p_stock_limite INT)
BEGIN
    SELECT p.id_producto, p.nombre, cat.nombre AS categoria, p.stock, p.precio
    FROM productos p
    INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
    WHERE p.id_categoria = p_id_categoria AND p.stock < p_stock_limite;
END $$

CALL productos_bajo_stock(2, 10);

-- 3. Mostrar ventas realizadas por un cliente especifico en un rango de fechas
DELIMITER $$
CREATE PROCEDURE ventas_cliente_fechas(IN p_id_cliente INT, IN p_fecha_inicio DATETIME, IN p_fecha_fin DATETIME)
BEGIN
    SELECT v.id_venta, v.fecha_venta, c.nombre_completo AS cliente, e.nombre_completo AS empleado,SUM(dv.cantidad * dv.precio_unitario) AS total_venta
    FROM ventas v
    INNER JOIN clientes c ON v.id_cliente = c.id_cliente
    INNER JOIN empleados e ON v.id_empleado = e.id_empleado
    INNER JOIN detalles_venta dv ON v.id_venta = dv.id_venta
    WHERE v.id_cliente = p_id_cliente AND v.fecha_venta BETWEEN p_fecha_inicio AND p_fecha_fin
    GROUP BY v.id_venta, v.fecha_venta, c.nombre_completo, e.nombre_completo;
END $$

DELIMITER ; 

CALL ventas_cliente_fechas(1, '2026-10-01', '2026-10-31');


-- 4. Calcular el total de ventas realizadas por un empleado en un mes dado 

DELIMITER $$
CREATE FUNCTION fn_total_ventas_empleado_mes(p_id_empleado INT, p_anio INT, p_mes INT) 
RETURNS DECIMAL(10,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(10,2) DEFAULT 0.00;
    
    SELECT COALESCE(SUM(dv.cantidad * dv.precio_unitario), 0.00) INTO v_total
    FROM ventas v
    INNER JOIN detalles_venta dv ON v.id_venta = dv.id_venta
    WHERE v.id_empleado = p_id_empleado AND YEAR(v.fecha_venta) = p_anio AND MONTH(v.fecha_venta) = p_mes;
      
    RETURN v_total;
END $$

SELECT fn_total_ventas_empleado_mes(1, 2026, 10) AS total_ventas_octubre;

-- 5. Listar los productos mas vendidos en un periodo determinado
DELIMITER $$
CREATE PROCEDURE productos_mas_vendidos(IN p_fecha_inicio DATETIME, IN p_fecha_fin DATETIME, IN p_limite INT)
BEGIN
    SELECT p.id_producto, p.nombre, cat.nombre AS categoria, SUM(dv.cantidad) AS total_unidades_vendidas
    FROM detalles_venta dv
    INNER JOIN ventas v ON dv.id_venta = v.id_venta
    INNER JOIN productos p ON dv.id_producto = p.id_producto
    INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
    WHERE v.fecha_venta BETWEEN p_fecha_inicio AND p_fecha_fin
    GROUP BY p.id_producto, p.nombre, cat.nombre
    ORDER BY total_unidades_vendidas DESC
    LIMIT p_limite;
END $$

DELIMITER ; 

CALL productos_mas_vendidos('2026-01-01', '2026-12-31', 5);

-- 6. Consultar stock disponible de un producto por su nombre o ID
DELIMITER $$
CREATE PROCEDURE consultar_stock_producto(IN p_busqueda VARCHAR(100))
BEGIN
    SELECT id_producto, nombre, stock, precio
    FROM productos
    WHERE id_producto = CAST(p_busqueda AS UNSIGNED) OR LOWER(nombre) LIKE CONCAT('%', LOWER(p_busqueda), '%');
END $$

DELIMITER ;

CALL consultar_stock_producto('Labial');

-- 7. Mostrar ordenes de compra realizadas a un proveedor especifico en el ultimo año
DELIMITER $$
CREATE PROCEDURE ordenes_compra_proveedor_ultimo_anio(IN p_id_proveedor INT)
BEGIN
    SELECT oc.id_orden, oc.fecha_orden, pr.nombre_empresa,
           SUM(doc.cantidad_solicitada) AS total_solicitado,
           SUM(doc.cantidad_recibida) AS total_recibido
    FROM ordenes_compra oc
    INNER JOIN proveedores pr ON oc.id_proveedor = pr.id_proveedor
    INNER JOIN detalles_orden_compra doc ON oc.id_orden = doc.id_orden
    WHERE oc.id_proveedor = p_id_proveedor 
      AND oc.fecha_orden >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
    GROUP BY oc.id_orden, oc.fecha_orden, pr.nombre_empresa;
END $$

DELIMITER ;

CALL ordenes_compra_proveedor_ultimo_anio(1);

-- 8. Listar empleados que han trabajado mas de un año en la tienda
DELIMITER $$
CREATE PROCEDURE empleados_mas_de_un_anio()
BEGIN
    SELECT e.id_empleado, e.nombre_completo, e.puesto, a.nombre AS area, e.fecha_contratacion, DATEDIFF(CURDATE(), e.fecha_contratacion) / 365 AS anios_trabajados
    FROM empleados e
    INNER JOIN areas a ON e.id_area = a.id_area
    WHERE e.fecha_contratacion <= DATE_SUB(CURDATE(), INTERVAL 1 YEAR);
END $$

DELIMITER ; 

CALL empleados_mas_de_un_anio();

-- 9. Obtener la cantidad total de productos vendidos en un dia especifico
DELIMITER $$
CREATE FUNCTION fn_total_productos_vendidos_dia(p_fecha DATE) 
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE v_cantidad INT DEFAULT 0;
    
    SELECT COALESCE(SUM(dv.cantidad), 0) INTO v_cantidad
    FROM ventas v
    INNER JOIN detalles_venta dv ON v.id_venta = dv.id_venta
    WHERE DATE(v.fecha_venta) = p_fecha;
    
    RETURN v_cantidad;
END $$

DELIMITER ; 

SELECT fn_total_productos_vendidos_dia('2026-10-01') AS productos_vendidos;

-- 10. Consultar las ventas de un producto especifico (por nombre o ID) y unidades vendidas
DELIMITER $$
CREATE PROCEDURE ventas_por_producto(IN p_busqueda VARCHAR(100))
BEGIN
    SELECT p.id_producto, p.nombre, COUNT(DISTINCT v.id_venta) AS total_transacciones, COALESCE(SUM(dv.cantidad), 0) AS total_unidades_vendidas, COALESCE(SUM(dv.cantidad * dv.precio_unitario), 0.00) AS ingreso_total
    FROM productos p
    LEFT JOIN detalles_venta dv ON p.id_producto = dv.id_producto
    LEFT JOIN ventas v ON dv.id_venta = v.id_venta
    WHERE p.id_producto = CAST(p_busqueda AS UNSIGNED) OR LOWER(p.nombre) LIKE CONCAT('%', LOWER(p_busqueda), '%')
    GROUP BY p.id_producto, p.nombre;
END $$

DELIMITER ;

CALL ventas_por_producto('1');