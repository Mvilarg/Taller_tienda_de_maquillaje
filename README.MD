# Sistema de Gestión de Base de Datos - Tienda de Maquillaje 💄✨

Este repositorio contiene el diseño, implementación y consultas para la base de datos relacional de una **Tienda de Maquillaje**, desarrollada en **MySQL**. El sistema permite gestionar información sobre productos, características específicas por categoría, inventario, clientes, empleados, proveedores, ventas y órdenes de compra.

---


## 📐 Modelo Entidad-Relación (E-R)

### Descripción de las Entidades y Relaciones

1. **`categorias`**: Define las categorías de productos (Cosméticos, Cuidado de la Piel, Perfumes, Accesorios).
2. **`productos`**: Tabla central del catálogo que registra el nombre, descripción, precio, stock y la categoría a la que pertenece.
3. **`caracteristicas`**: Tabla de extensión (relación 1:1 con `productos`) que unifica las propiedades específicas según el tipo de producto (tipo/subtipo, tono/color, tamaño, material, aroma, componentes y fecha de expiración), permitiendo valores `NULL` para atributos no requeridos por la categoría.
4. **`clientes`**: Mantiene los registros de los compradores (nombre, correo electrónico, dirección y teléfono).
5. **`areas`**: Departamentos de trabajo de la empresa (Venta, Bodega, Administración).
6. **`empleados`**: Personal contratado registrado con su puesto y área asignada.
7. **`ventas` y `detalles_venta`**: Registro de las transacciones efectuadas a clientes, indicando la fecha, el empleado atendedor, los productos adquiridos, cantidades y precios de venta.
8. **`proveedores`**, **`ordenes_compra`** y **`detalles_orden_compra`**: Control de reabastecimiento y gestión de pedidos realizados a proveedores con control de cantidades solicitadas y recibidas.

---
## 📁 Estructura del Repositorio

```text
.
├── README.md             # Documentación principal del proyecto
├── DDL.sql               # Script de definición de estructura (Tablas y Llaves)
├── DML.sql               # Script de inserción de datos de prueba
├── DQL.sql               # Script con funciones, procedimientos y consultas
└── UML.PNG               # Diagrama entidad relacion
```

---