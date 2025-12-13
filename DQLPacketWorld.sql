use packetworld;

SELECT 
    c.idColaborador,
    c.nombre,
    c.apellidoPaterno,
    c.apellidoMaterno,
    c.CURP,
    c.correo,
    c.noPersonal,
    c.contrasenia,
    c.fotografia,
    c.idRol,
    c.idSucursal,
    d.numero_licencia AS numeroLicencia
FROM COLABORADOR c
INNER JOIN CONDUCTOR d ON c.idColaborador = d.idConductor
WHERE c.noPersonal = 'PW003' 
  AND c.contrasenia = 'drive123';