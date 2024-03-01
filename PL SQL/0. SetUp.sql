--
-- Iniciar Sesion
--

/*
Por terminal es más facil crear usuarios y darles permisos,
recomendado hacer esa parte ahi.
*/

-- Establecer conexion
conn system
SET SERVEROUTPUT ON --RITUAL PARA HACER SIEMPRE EN CONSOLA
                     -- ( Hace que se pueda imprimir los resultados en consola)
-- Crear usuario
ALTER SESSION SET “_ORACLE_SCRIPT” = TRUE -- Necesario for some reason
CREATE USER [nombre_usuario] IDENTIFIED BY [contraseña];

GRANT CONNECT, RESOURCE TO [nombre_usuario];
GRANT CREATE ANY TABLE TO [nombre_usuario];
GRANT CREATE ANY PROCEDURE TO [nombre_usuario];
GRANT CREATE ANY VIEW TO [nombre_usuario];

ALTER USER [nombre_usuario] QUOTA UNLIMITED ON USERS; -- Necesario for some reason

-- Esto evita dolores de cabeza cuando se meten fechas
-- Asi solo usas el que esta abajo y ya
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';

-- Tabla de Prueba
DROP TABLE Empleados;
// Create Tables
CREATE TABLE Empleados(
   cod NUMBER(8) PRIMARY KEY,
   nombre VARCHAR2(10) NOT NULL,
   fecha_inicio DATE,
   sueldo NUMBER(8) CHECK(sueldo > 0)
   );

-- Valores de Prueba
INSERT INTO empleados(cod,nombre,fecha_inicio,sueldo) VALUES(1,'Pizza','2000-05-21',1000);
INSERT INTO empleados(cod,nombre,fecha_inicio,sueldo) VALUES(2,'Tacos','2002-12-12',500);
INSERT INTO empleados(cod,nombre,fecha_inicio,sueldo) VALUES(3,'Hamburguesa','2001-01-02',200);
INSERT INTO empleados(cod,nombre,fecha_inicio,sueldo) VALUES(4,'Sushi','1999-05-05',100);
INSERT INTO empleados(cod,nombre,fecha_inicio,sueldo) VALUES(5,'Mandarina','2008-11-11',5);

/*
Herramientas para mejorar la experiencia SQL
* DBeaver 
   - se puede obtener la version ENTERPRISE gratis por medio de la universidad
   - La community es gratuita
* Beekeeper studio
   - Da dos semanas gratis de ultimate

La configuración GENERAL en estas Herramientas:
- Host: si no sirve localhost, intentar con el nombre de tu equipo
- User: usuario que creaste o SYSTEM si no creaste alguno
- Password: password que escogiste en la instalación o creando el usuario

*/