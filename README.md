# Dos opciones para cargar la base de datos

### A) Importación de la base de datos
1. Crear base de datos con el nombre `packetworld`
```mysql
DROP DATABASE IF EXISTS packetworld;
CREATE DATABASE packetworld DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci;
USE packetworld;
DROP USER IF EXISTS 'packet_admin'@'localhost';
CREATE USER 'packet_admin'@'localhost' IDENTIFIED BY 'X9#mK2$vP5&dL!8qR3*zW';
GRANT ALL PRIVILEGES ON packetworld.* TO 'packet_admin'@'localhost';
FLUSH PRIVILEGES;
```
3. Importar base de datos `export.sql` a `packetworld`

### B) Creación manual de la base de datos con scripts

1. Crear base de datos con el nombre `packetworld`
2. Ejecutar el script `DDLPacketWorld.sql` de la línea `1` a la `6`
3. Importar base de datos `mexico.sql` a `packetworld`
4. Ejecutar el script `DDLPacketWorld.sql` a partir de la línea `13`
5. Ejecutar el script `DMLPacketWorld.sql`
