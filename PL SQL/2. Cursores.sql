-- BEFORE
DROP TABLE emp;
CREATE TABLE emp(
    cod NUMBER(8) PRIMARY KEY,
    nombre VARCHAR2(15),
    dep NUMBER(3),
    sueldo NUMBER(8) NOT NULL
);

INSERT INTO emp VALUES(12, 'Jessie J', 1,100);
INSERT INTO emp VALUES(15, 'Rihanna', 2, 300);
INSERT INTO emp VALUES(76, 'Aaliyah', 2, 400);
INSERT INTO emp VALUES(73, 'Emilia Clarke', 5, 500);
INSERT INTO emp VALUES(56, 'Jessy', 3, 100);

--
-- CURSORES
--

-- Metodo 1
DECLARE
    CURSOR codigo_dep IS SELECT cod, dep FROM emp ORDER BY dep;
    codi emp.cod%TYPE;
    dpti emp.dep%TYPE;
BEGIN
    OPEN codigo_dep;
    LOOP
        FETCH codigo_dep INTO codi, dpti;
        EXIT WHEN codigo_dep%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Codigo:' ||  codi || ', Departamento: ' || dpti);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Total: ' || codigo_dep%ROWCOUNT);
    CLOSE codigo_dep;
END;
/

-- Metodo 2
DECLARE
    CURSOR codigo_dep IS --Se declara el cursor
    SELECT cod, dep FROM emp ORDER BY dep;
BEGIN
    FOR fila IN codigo_dep LOOP
        DBMS_OUTPUT.PUT_LINE('Codigo:' ||  fila.cod || ', Departamento: ' || fila.dep);
    END LOOP;
    --DBMS_OUTPUT.PUT_LINE('Total: ' || ord_c%ROWCOUNT);
END;
/

-- Metodo 3
BEGIN
    FOR fila IN (SELECT cod, dep FROM emp ORDER BY dep)
    LOOP
        DBMS_OUTPUT.PUT_LINE('Codigo:' ||  fila.cod || ', Departamento: ' || fila.dep);
    END LOOP;
END;
/

-- Con Parametros
DECLARE
    totalSucursal NUMBER(5);
    totalGeneral NUMBER(6) := 0;
    CURSOR empleados(departamento_empleado NUMBER) IS SELECT nombre FROM emp WHERE dep = departamento_empleado;
BEGIN
    -- Recorre 5 veces con k variando el valor
    -- Para ejecutar 5 consultas de manera tal que por cada Departamento haga algo.
    FOR k IN 1..5 LOOP
        DBMS_OUTPUT.PUT_LINE('-----Dpto: ' || k || '-------');
        totalSucursal := 0;
        -- AQUI SE ASIGNA EL PARAMETRO CON "empleados(k)  con k valiendo 1..5"
        FOR empleado IN empleados(k) LOOP
            DBMS_OUTPUT.PUT_LINE(empleado.nombre);
            totalSucursal := totalSucursal + 1;
        END LOOP;
        -- Se imprimen los empleados del departamento y se llevan a la cuenta general
        DBMS_OUTPUT.PUT_LINE('Total empleados en sucursal:' || totalSucursal);
        totalGeneral := totalGeneral + totalSucursal;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('----------------');
    DBMS_OUTPUT.PUT_LINE('Total empleados en la empresa: ' || totalGeneral);
END;
/

-- XML

DROP TABLE bodega;
CREATE TABLE bodega(
    id NUMBER(4) PRIMARY KEY,
    documento XMLTYPE
);

INSERT INTO bodega VALUES(100, XMLTYPE(
    '<Warehouse whNo="5">
    <Building>Owned</Building>
    </Warehouse>'
    ));
INSERT INTO bodega VALUES(200, XMLTYPE(
    '<Warehouse whNo="8">
    <Building>Rented</Building>
    <Tel>21287</Tel>
    </Warehouse>'
    ));

DECLARE
    suma_meta_tags NUMBER(8) := 0;
BEGIN
    FOR fila IN (SELECT bodega.*,
        EXTRACTVALUE(documento,'/Warehouse/@whNo') AS meta_tag,
        EXTRACTVALUE(documento,'/Warehouse/Building') AS contenido FROM bodega) LOOP
        -- ( Parece complejo pero es de mi ensayo y error para que imprima bonito )
            DBMS_OUTPUT.PUT_LINE(
                -- Imprime el Id de la fila, o de la bodega
                '--------'||CHR(10)|| 
                fila.id || CHR(10) ||
                -- Imprime el documento
                '--------'|| CHR(10) ||
                fila.documento.EXTRACT('/*').getStringVal()||
                '--------'|| CHR(10) ||
                -- Imprime el tag y el contenido deseado
                'Meta Tag: ' || fila.meta_tag || CHR(10) ||
                'Contenido -> ' || fila.contenido);
            -- Suma los tags
            suma_meta_tags := suma_meta_tags + fila.meta_tag;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('----------------');
    DBMS_OUTPUT.PUT_LINE('Total Warehouse tags: ' || suma_meta_tags);
    DBMS_OUTPUT.PUT_LINE('----------------');
END;
/


-- JSON

DROP TABLE depjson;
CREATE TABLE depjson (
    cod NUMBER(8) PRIMARY KEY,
    dep_data JSON NOT NULL
);
INSERT INTO depjson VALUES (110,
    '{
        "nombredep": "Música",
        "empleados": [
            {
            "nombre": "Aina Roxx",
            "trabajo": "Corista"
            },
            {
            "nombre": "Cath Coffey",
            "trabajo": "Cantante principal"
            }
        ]
    }'
);

SELECT d.dep_data.empleados FROM depjson d;
SELECT d.dep_data.empleados[1] FROM depjson d;
SELECT d.dep_data.empleados[1].nombre FROM depjson d;

DECLARE
    mijson JSON;
BEGIN
    SELECT dep_data INTO mijson FROM depjson;
    DBMS_OUTPUT.PUT_LINE(JSON_SERIALIZE(mijson PRETTY));
END;
/