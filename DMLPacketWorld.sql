use packetworld;

-- 2.1 Catálogos básicos
INSERT INTO ESTATUS_ENVIO (nombre) VALUES
    ('recibido en sucursal'),
    ('procesado'),
    ('en tránsito'),
    ('detenido'),
    ('entregado'),
    ('cancelado');

INSERT INTO ROL (rol) VALUES
    ('Administrador'),
    ('Ejecutivo de tienda'),
    ('Conductor');

INSERT INTO TIPO_UNIDAD (tipo) VALUES
    ('Gasolina'),
    ('Diesel'),
    ('Eléctrica'),
    ('Híbrida');

-- 2.3 Direcciones
INSERT INTO DIRECCION (calle, numero, idColonia) VALUES
    ('Calle Enríquez', '12', 10011),
    ('Av. Álvaro Obregón', '45', 10012),
    ('Calle Araucarias', '105', 10013),
    ('Calle Martí', '200', 10014),
    ('Salinas', 'Int. 32', 10012),
    ('Nicolas', '28', 10011);

-- 2.4 Sucursales
INSERT INTO SUCURSAL (codigo, nombre, idDireccion) VALUES
    ('SUC-XAL-01', 'PacketWorld Xalapa Centro', 1),
    ('SUC-CDMX-01', 'PacketWorld Roma Norte', 2);

-- 2.5 Colaboradores
INSERT INTO COLABORADOR (nombre, apellidoPaterno, apellidoMaterno, CURP, correo, noPersonal, contrasenia, idRol, idSucursal) VALUES
    ('Juan', 'Pérez', 'López', 'PELJ800101HVZR01', 'admin@packetworld.com', 'PW001', 'admin123', 1, 1),
    ('María', 'González', 'Rui', 'GORM900202HVZR02', 'maria.ventas@packetworld.com', 'PW002', 'user123', 2, 1),
    ('Pedro', 'Hernández', 'Sola', 'HESP850303HVZR03', 'pedro.driver@packetworld.com', 'PW003', 'drive123', 3, 1),
    ('Luis', 'Ramírez', 'Cruz', 'RACL880404HDFR04', 'luis.driver@packetworld.com', 'PW004', 'drive123', 3, 2);

-- 2.6 Conductores
INSERT INTO CONDUCTOR (idConductor, numero_licencia) VALUES
    (3, 'VER-LIC-A-000123'),
    (4, 'CDMX-LIC-B-999888');

-- 2.7 Flota Vehicular
INSERT INTO UNIDAD (marca, modelo, anio, VIN, estatus, idTipoUnidad) VALUES
    ('Nissan', 'NP300', 2023, '3N6CM012345678901', 'activa', 1),
    ('Ford', 'Transit', 2022, '1FTYR123456789012', 'activa', 2),
    ('BYD', 'T3', 2024, 'LGVX1234567890123', 'activa', 3);

-- 2.8 Asignación de Unidad a Conductor
INSERT INTO UNIDAD_CONDUCTOR (idUnidad, idConductor) VALUES
    (1, 3);

-- 2.9 Clientes
INSERT INTO CLIENTE (nombre, apellidoPaterno, apellidoMaterno, telefono, correo, idDireccion) VALUES
    ('Ana', 'Torres', 'Méndez', '2281234567', 'ana.cliente@gmail.com', 3),
    ('Carlos', 'Ruiz', 'Zafón', '2299876543', 'carlos.cliente@hotmail.com', 4);

-- 2.11 Envíos
INSERT INTO ENVIO (
    noGuia, 
    costo, 
    destinatarioNombre, 
    destinatarioApellidoPaterno, 
    destinatarioApellidoMaterno, 
    destinatarioIdDireccion,
    idEstatusEnvio, 
    idSucursalOrigen, 
    idConductor,
    idCliente
) VALUES
    ('GUIA-00002', 120.00, 'Roberto', 'Gómez', 'Bolaños', 5, 2, 1, 3, 1),
    ('GUIA-00001', 0.00, 'Víctor', 'Monge', 'Morales', 6, 1, 1, 4, 1);

-- 2.12 Paquetes
INSERT INTO PAQUETE (idEnvio, descripcion, peso, alto, ancho, profundidad) VALUES
    (1, 'Caja con componentes electrónicos', 2.5, 30.0, 20.0, 15.0),
    (1, 'Caja', 2.5, 30.0, 20.0, 15.0),
    (2, 'Sobre con documentos legales', 0.2, 1.0, 25.0, 35.0);

-- 2.13 Historial de Estatus
INSERT INTO ENVIO_HISTORIAL_ESTATUS (idEnvio, idColaborador, idEstatusEnvio, fechaHora, comentario) VALUES
    (1, 2, 1, '2023-10-01 09:00:00', 'Paquete recibido en ventanilla sin daños'),
    (1, 1, 2, '2023-10-01 10:00:00', 'Documentación validada'),
    (1, 3, 3, '2023-10-01 12:00:00', 'Salida a ruta foránea'),
    (2, 2, 1, '2023-10-02 09:30:00', NULL);
