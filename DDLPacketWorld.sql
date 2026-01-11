DROP DATABASE IF EXISTS packetworld;

-- UTF8MB4 para soporte completo de caracteres
-- utf8_unicode_ci utiliza el algoritmo de clasificación Unicode recomendado en los estándares Unicode
CREATE DATABASE packetworld DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci;
USE packetworld;

-- ----------------------------------------------------------------------------
-- 1.1 TABLAS DE CATÁLOGOS Y DIRECCIONES
-- ----------------------------------------------------------------------------

-- Tabla catálogo de roles de usuarios del sistema
CREATE TABLE ROL (
    idRol INT PRIMARY KEY AUTO_INCREMENT,
    rol VARCHAR(50) NOT NULL UNIQUE
);

-- Tabla catálogo de los tipos de vehiculos
CREATE TABLE TIPO_UNIDAD (
    idTipoUnidad INT PRIMARY KEY AUTO_INCREMENT,
    tipo VARCHAR(50) NOT NULL UNIQUE
);

-- TABLA catálogo de estados de envío
CREATE TABLE ESTATUS_ENVIO (
    idEstatusEnvio INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

-- ----------------------------------------------------------------------------
-- No se agregan ya que se importan de un archivo externo

-- CREATE TABLE PAISES (
--    id INT PRIMARY KEY AUTO_INCREMENT,
--    nombre VARCHAR(50) NOT NULL
-- );

-- CREATE TABLE ESTADOS (
--    id INT PRIMARY KEY AUTO_INCREMENT,
--    nombre VARCHAR(100) NOT NULL,
--    pais INT NOT NULL,
--    FOREIGN KEY (pais) REFERENCES PAISES(id)
-- );

-- CREATE TABLE MUNICIPIOS (
--    id INT PRIMARY KEY AUTO_INCREMENT,
--    nombre VARCHAR(50) NOT NULL,
--    estado INT NOT NULL,
--    FOREIGN KEY (estado) REFERENCES ESTADOS(id)
-- );

-- CREATE TABLE COLONIAS (
--    id INT PRIMARY KEY AUTO_INCREMENT,
--    nombre VARCHAR(100) NOT NULL,
--    ciudad VARCHAR(50) NOT NULL,
--    codigo_postal NOT NULL,
--    asentamiento VARCHAR(25),
--    municipio INT NOT NULL,
--    FOREIGN KEY (municipio) REFERENCES MUNICIPIOS(id)
-- );
-- ----------------------------------------------------------------------------

-- Tabla para direcciones
CREATE TABLE DIRECCION (
    idDireccion INT PRIMARY KEY AUTO_INCREMENT,
    calle VARCHAR(100) NOT NULL,
    numero VARCHAR(20),
    idColonia INT NOT NULL,
    FOREIGN KEY (idColonia) REFERENCES COLONIAS(id)
);

-- ----------------------------------------------------------------------------
-- 1.2 TABLAS DE ENTIDADES PRINCIPALES
-- ----------------------------------------------------------------------------

-- Tabla para las sucursales
CREATE TABLE SUCURSAL (
    idSucursal INT PRIMARY KEY AUTO_INCREMENT,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    estatus ENUM('activa', 'inactiva') NOT NULL DEFAULT 'activa',
    idDireccion INT NOT NULL,
    FOREIGN KEY (idDireccion) REFERENCES DIRECCION(idDireccion)
);

-- Tabla para los colaboradores
CREATE TABLE COLABORADOR (
    idColaborador INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    apellidoPaterno VARCHAR(100),
    apellidoMaterno VARCHAR(100),
    CURP CHAR(18) NOT NULL UNIQUE,
    correo VARCHAR(255) NOT NULL UNIQUE,
    noPersonal VARCHAR(20) NOT NULL UNIQUE,
    contrasenia VARCHAR(255) NOT NULL,
    fotografia LONGBLOB,
    idRol INT NOT NULL,
    idSucursal INT NOT NULL,
    FOREIGN KEY (idRol) REFERENCES ROL(idRol),
    FOREIGN KEY (idSucursal) REFERENCES SUCURSAL(idSucursal)
);

-- Tabla separada para conductores
CREATE TABLE CONDUCTOR (
    idConductor INT PRIMARY KEY,
    numero_licencia VARCHAR(50) NOT NULL,
    FOREIGN KEY (idConductor) REFERENCES COLABORADOR(idColaborador) ON DELETE CASCADE
);

-- Tabla para los clientes
CREATE TABLE CLIENTE (
    idCliente INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    apellidoPaterno VARCHAR(100) NOT NULL,
    apellidoMaterno VARCHAR(100),
    telefono VARCHAR(15) NOT NULL,
    correo VARCHAR(255) NOT NULL,
    idDireccion INT NOT NULL,
    FOREIGN KEY (idDireccion) REFERENCES DIRECCION(idDireccion)
);

-- Tabla para las unidades
CREATE TABLE UNIDAD (
    idUnidad INT PRIMARY KEY AUTO_INCREMENT,
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    anio INT NOT NULL,
    VIN VARCHAR(17) NOT NULL UNIQUE,
    NII VARCHAR(10) GENERATED ALWAYS AS (CONCAT(anio, SUBSTRING(VIN, 1, 4))) STORED, -- TODO: revisar si es mejor así o generarlo en la aplicación
    estatus ENUM('activa', 'baja'),
    idTipoUnidad INT NOT NULL,
    FOREIGN KEY (idTipoUnidad) REFERENCES TIPO_UNIDAD(idTipoUnidad)
);

-- Tabla de relación entre unidad y conductor
CREATE TABLE UNIDAD_CONDUCTOR (
    idUnidad INT PRIMARY KEY,
    idConductor INT UNIQUE NOT NULL,
    FOREIGN KEY (idUnidad) REFERENCES UNIDAD(idUnidad),
    FOREIGN KEY (idConductor) REFERENCES CONDUCTOR(idConductor) ON DELETE CASCADE
);

-- Tabla para bajas de unidades
CREATE TABLE UNIDAD_BAJA (
    idBaja INT PRIMARY KEY AUTO_INCREMENT,
    idUnidad INT NOT NULL,
    motivoBaja TEXT NOT NULL,
    fechaBaja TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    idColaborador INT,
    FOREIGN KEY (idUnidad) REFERENCES UNIDAD(idUnidad),
    FOREIGN KEY (idColaborador) REFERENCES COLABORADOR(idColaborador) ON DELETE SET NULL
);

-- ----------------------------------------------------------------------------
-- 1.3 TABLAS DE GESTIÓN DE ENVÍOS
-- ----------------------------------------------------------------------------

-- Tabla de envíos
CREATE TABLE ENVIO (
    idEnvio INT PRIMARY KEY AUTO_INCREMENT,
    noGuia VARCHAR(50) NOT NULL UNIQUE,
    costo DECIMAL(10, 2) NOT NULL DEFAULT 0.00,

    destinatarioNombre VARCHAR(100) NOT NULL,
    destinatarioApellidoPaterno VARCHAR(100),
    destinatarioApellidoMaterno VARCHAR(100),
    destinatarioIdDireccion INT NOT NULL,

    idEstatusEnvio INT NOT NULL,
    idSucursalOrigen INT NOT NULL,
    idConductor INT,
    idCliente INT,
    FOREIGN KEY (idCliente) REFERENCES CLIENTE(idCliente) ON DELETE SET NULL,
    FOREIGN KEY (idConductor) REFERENCES CONDUCTOR(idConductor) ON DELETE SET NULL,
    FOREIGN KEY (idSucursalOrigen) REFERENCES SUCURSAL(idSucursal),
    FOREIGN KEY (idEstatusEnvio) REFERENCES ESTATUS_ENVIO(idEstatusEnvio),
    FOREIGN KEY (destinatarioIdDireccion) REFERENCES DIRECCION(idDireccion)
);

-- Tabla de paquetes
CREATE TABLE PAQUETE (
    idPaquete INT PRIMARY KEY AUTO_INCREMENT,
    idEnvio INT NOT NULL,
    descripcion TEXT NOT NULL,
    peso DECIMAL(10, 2) NOT NULL,
    alto DECIMAL(10, 2) NOT NULL,
    ancho DECIMAL(10, 2) NOT NULL,
    profundidad DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (idEnvio) REFERENCES ENVIO(idEnvio) ON DELETE CASCADE
);

-- Tabla de historial de cambios de estado
CREATE TABLE ENVIO_HISTORIAL_ESTATUS (
    idHistorial INT PRIMARY KEY AUTO_INCREMENT,
    idEnvio INT NOT NULL,
    idColaborador INT,
    idEstatusEnvio INT NOT NULL,
    fechaHora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    comentario TEXT DEFAULT NULL,
    FOREIGN KEY (idEnvio) REFERENCES ENVIO(idEnvio) ON DELETE CASCADE,
    FOREIGN KEY (idColaborador) REFERENCES COLABORADOR(idColaborador) ON DELETE SET NULL,
    FOREIGN KEY (idEstatusEnvio) REFERENCES ESTATUS_ENVIO(idEstatusEnvio)
);

-- ----------------------------------------------------------------------------
-- 1.4 TRIGGERS
-- ----------------------------------------------------------------------------

DELIMITER //

DROP TRIGGER IF EXISTS trg_eliminar_direccion_envio //
CREATE TRIGGER trg_eliminar_direccion_envio
    AFTER DELETE ON ENVIO
    FOR EACH ROW
BEGIN
    DELETE FROM DIRECCION
    WHERE idDireccion = OLD.destinatarioIdDireccion;
END //

DROP TRIGGER IF EXISTS trg_eliminar_direccion_cliente //
CREATE TRIGGER trg_eliminar_direccion_cliente
    AFTER DELETE ON CLIENTE
    FOR EACH ROW
BEGIN
    DELETE FROM DIRECCION
    WHERE idDireccion = OLD.idDireccion;
END //

DELIMITER ;

-- ----------------------------------------------------------------------------
-- USUARIOS Y PRIVILEGIOS
-- ----------------------------------------------------------------------------
    
DROP USER IF EXISTS 'packet_admin'@'localhost';
    
CREATE USER 'packet_admin'@'localhost' IDENTIFIED BY 'X9#mK2$vP5&dL!8qR3*zW';

-- Otorgar todos los permisos SOBRE la base de datos packetworld SOLAMENTE
GRANT ALL PRIVILEGES ON packetworld.* TO 'packet_admin'@'localhost';

-- Aplicar los cambios de privilegios
FLUSH PRIVILEGES;