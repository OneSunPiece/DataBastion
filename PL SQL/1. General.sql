DECLARE
    nom empleados.nombre%TYPE;
    sue empleados.sueldo%TYPE;
    cuantos NUMBER(8);
BEGIN
    SELECT nombre, sueldo INTO nom, sue FROM empleados WHERE cod = 1;

    DBMS_OUTPUT.PUT_LINE('El empleado ' || nom || '
    tiene sueldo ' || sue);

    SELECT COUNT(*) INTO cuantos FROM empleados;

    DBMS_OUTPUT.PUT_LINE('Total empleados ' || cuantos);
END;

