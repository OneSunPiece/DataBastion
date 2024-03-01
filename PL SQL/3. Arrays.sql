--
-- ARRAYS
--

DECLARE
    -- Defino el tipo que tendra mi arreglo
    TYPE tipo_arreglo IS TABLE OF NUMBER(3) INDEX BY BINARY_INTEGER;
    -- Defino el arreglo ahora si
    mi_arreglo tipo_arreglo;
    -- Este para usar de index en el arreglo
    i NUMBER;
BEGIN
    -- mi_arreglo( [Position en el arreglo] ) := Numero aleatorio
    mi_arreglo(9) := MOD(DBMS_RANDOM.RANDOM,1000);
    mi_arreglo(4) := MOD(DBMS_RANDOM.RANDOM,1000);
    mi_arreglo(2) := MOD(DBMS_RANDOM.RANDOM,1000);
    mi_arreglo(1) := 999; ---1000 ya no se puede
    mi_arreglo(0) := 1;
    DBMS_OUTPUT.PUT_LINE(
        'tamaño del arreglo: ' || CHR(10)||
        mi_arreglo.COUNT);
    --mi_arreglo.DELETE(4); -- Descomentar si quieren, solo borra la posicion 4

    i := mi_arreglo.FIRST;
    WHILE i IS NOT NULL LOOP
        DBMS_OUTPUT.PUT_LINE('Pos:'|| i || ' Val:' || mi_arreglo(i));
        i := mi_arreglo.NEXT(i);
    END LOOP;

END;
/

---
--- MATRICES
---
-- [A  B  C]
-- [D  E  F]
-- [G  H  I]

DECLARE
    -- Defino un tipo de array
    TYPE tipo_arreglo IS TABLE OF NUMBER(3) INDEX BY BINARY_INTEGER;
    -- La matriz es un arreglo cuyos elementos son arreglos
    TYPE tipo_matriz IS TABLE OF tipo_arreglo INDEX BY BINARY_INTEGER;
    -- Declaro mi matriz
    matriz tipo_matriz;
BEGIN
    -- Loop A : Llena la matriz de numeros aleatorios
    FOR i IN 1..10 LOOP
        -- segundo Loop A
        FOR j IN 1..10 LOOP
            matriz(i)(j) := MOD(DBMS_RANDOM.RANDOM,1000);
        END LOOP;
    END LOOP;
    -- Loop B : Imprime la matriz
    FOR i IN 1..matriz.COUNT LOOP
        -- segundo Loop B
        FOR j IN 1..matriz(i).COUNT LOOP
            DBMS_OUTPUT.PUT_LINE('Fila ' || i || ' Col ' || j || ': ' ||
            matriz(i)(j));
        END LOOP;
    END LOOP;
END;
/

--- EXPLORACION

DECLARE
    TYPE t_empleado IS TABLE OF emp%ROWTYPE
    INDEX BY BINARY_INTEGER;
    mis_emp t_empleado; -- Array de empleados
    k NUMBER(8) := 1;
BEGIN
    -- LOOP A: añade empleados a un array
    FOR mi_e IN (SELECT * FROM emp ORDER BY sueldo, cod) LOOP
        mis_emp(k) := mi_e;
        k := k+1;
    END LOOP;

    IF k > 1 THEN --Hay al menos un empleado
        DBMS_OUTPUT.PUT_LINE(mis_emp(1).cod || ' ' || mis_emp(1).sueldo); -- Imprime el codigo y sueldo del primer trabajador (Menor sueldo y codigo primero)
        FOR i IN 2 .. mis_emp.COUNT LOOP --Para el resto de empleados
            DBMS_OUTPUT.PUT_LINE(mis_emp(i).cod || ' ' || mis_emp(i).sueldo || ' °°° ' ||
            mis_emp(i-1).sueldo);
            -- Imprime lo mismo pero con el sueldo del anterior
        END LOOP;
    END IF;
END;
/
--- ~ 0.1 segundos

--
-- TAREA
-- Comparar lo anterior con los siguientes codigos SQL
--

---1
SELECT cod, sueldo, LAG(sueldo,1) OVER (ORDER BY sueldo, cod) AS ant
FROM emp
ORDER BY sueldo, cod;

/*
Hace lo mismo pero más facil y corto (y al parecer eficiente)
~ 0.1 segundos
*/

---2
SELECT e1.cod, e1.sueldo,(
    SELECT MAX(sueldo) FROM emp e2
    WHERE e2.sueldo < e1.sueldo OR
    (e2.sueldo = e1.sueldo AND e2.cod < e1.cod)) AS ant
    FROM emp e1
    ORDER BY sueldo, cod;

/*
Hace lo mismo pero contruye manualmente la logica usada para seleccionar 
la consulta (el query)
~ 5 Segundos 
*/

------ PRUEBA DE RENDIMIENTO -------
BEGIN
    DELETE emp;
    FOR i IN 1..10000 LOOP
        INSERT INTO emp VALUES (i, 'Mariah'||i,
            CEIL(DBMS_RANDOM.VALUE(1,100)),
            CEIL(DBMS_RANDOM.VALUE(1,100000))
        );
    END LOOP;
END;
/

---
--- BULK COLLECT
---

DECLARE
    TYPE emp_type IS TABLE OF emp%ROWTYPE;
    arr emp_type;
    suma NUMBER(20) := 0;
BEGIN
    --Se llena el array de empleados por medio de BULK COLLECT
    SELECT * BULK COLLECT INTO arr FROM emp ORDER BY sueldo, cod;
    IF arr.FIRST IS NOT NULL THEN -- Hay al menos un empleado
        --Se recorre y se imprime el array de empleados
        FOR i IN arr.FIRST .. arr.LAST LOOP
            suma := suma + arr(i).sueldo;
            DBMS_OUTPUT.PUT_LINE('Cod: ' || arr(i).cod || ' ' || suma);
        END LOOP;
    END IF;
END;
/