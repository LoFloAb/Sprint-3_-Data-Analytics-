# Sprint 3 - Tasca S3.01. Manipulació de taules
# Nivell 1
## Exercici 1
### La teva tasca és dissenyar i crear una taula anomenada "credit_card" que emmagatzemi detalls crucials sobre les targetes de crèdit.
### La nova taula ha de ser capaç d'identificar de manera única cada targeta i establir una relació adequada amb les altres dues taules ("transaction" i "company").
### Després de crear la taula serà necessari que ingressis la informació del document denominat "dades_introduir_credit".
### Recorda mostrar el diagrama i realitzar una breu descripció d'aquest.
-- Para crear la tabla credit_card
CREATE TABLE IF NOT EXISTS credit_card (
	id VARCHAR(15) PRIMARY KEY,
	iban VARCHAR(255), 
	pan VARCHAR(100),
	pin VARCHAR(15),
	cvv VARCHAR(15),
	expiring_date VARCHAR(50)
);
    
-- Para agregar la FOREIGN KEY
ALTER TABLE transaction
ADD FOREIGN KEY (credit_card_id) REFERENCES credit_card(id);

## Exercici 2
### El departament de Recursos Humans ha identificat un error en el número de compte de l'usuari amb ID CcU-2938. 
### La informació que ha de mostrar-se per a aquest registre és: R323456312213576817699999. Recorda mostrar que el canvi es va realitzar.
-- Para verificar los datos que habían asignados al id CcU-2938
SELECT *
FROM credit_card
WHERE id = "CcU-2938";

-- Para actualizar el iban de "TR301950312213576817638661" que es erroneo, a "R323456312213576817699999" que es el correcto.
UPDATE credit_card
SET iban = "R323456312213576817699999"
WHERE id = "CcU-2938";

## Exercici 3
### En la taula "transaction" ingressa un nou usuari amb la següent informació:
-- Para agregar el id del nuevo usuario a la tabla credit_card
INSERT INTO credit_card (id) VALUE ("CcU-9999");

-- Para agregar el id del nuevo usuario a la tabla company
INSERT INTO company (id) VALUE ("b-9999");

-- Para ingresar el nuevo usuario
INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude, amount, declined)
VALUES ("108B1D1D-5B23-A76C-55EF-C568E49A99DD", "CcU-9999", "b-9999", "9999", "829.999", "-117.999", "111.11", "0");

## Exercici 4
### Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_card.
### Recorda mostrar el canvi realitzat.
-- Para hacer el DROP de la columna pan
ALTER TABLE credit_card DROP COLUMN pan;

-- Para ver la tabla credit_card sin la columna "pan"
SELECT *
FROM credit_card;

# Nivell 2
## Exercici 1
### Elimina de la taula transaction el registre amb ID 02C6201E-D90A-1859-B4EE-88D2986D3B02 de la base de dades.
-- Para eliminar el registro de la tabla transaction
DELETE FROM transaction WHERE id = "02C6201E-D90A-1859-B4EE-88D2986D3B02";

SELECT *
FROM transaction
WHERE id = "02C6201E-D90A-1859-B4EE-88D2986D3B02";

## Exercici 2
### La secció de màrqueting desitja tenir accés a informació específica per a realitzar anàlisi i estratègies efectives. 
### S'ha sol·licitat crear una vista que proporcioni detalls clau sobre les companyies i les seves transaccions. 
### Serà necessària que creïs una vista anomenada VistaMarketing que contingui la següent informació: 
### Nom de la companyia. Telèfon de contacte. País de residència. Mitjana de compra realitzat per cada companyia. 
### Presenta la vista creada, ordenant les dades de major a menor mitjana de compra.
CREATE VIEW VistaMarketing AS
SELECT company_name, phone, country, AVG(amount) AS average
FROM company
JOIN transaction ON company.id = transaction.company_id
GROUP BY company_id
ORDER BY average DESC;

-- Para ver la vista creada
SELECT *
FROM VistaMarketing;

## Exercici 3
### Filtra la vista VistaMarketing per a mostrar només les companyies que tenen el seu país de residència en "Germany"
SELECT *
FROM VistaMarketing
WHERE country = "Germany";

# Nivell 3
## Exercici 1
### La setmana vinent tindràs una nova reunió amb els gerents de màrqueting. 
### Un company del teu equip va realitzar modificacions en la base de dades, però no recorda com les va realitzar. 
### Et demana que l'ajudis a deixar els comandos executats per a obtenir el següent diagrama:
-- Cargar la estructura de los datos user
-- Cargar los datos user
-- Modificar la tabla credit_card
ALTER TABLE credit_card
ADD COLUMN fecha_actual DATE NULL DEFAULT NULL AFTER expiring_date,
CHANGE COLUMN id id VARCHAR(20) NOT NULL,
CHANGE COLUMN iban iban VARCHAR(50) NULL DEFAULT NULL,
CHANGE COLUMN pin pin VARCHAR(4) NULL DEFAULT NULL,
CHANGE COLUMN cvv cvv INT NULL DEFAULT NULL,
CHANGE COLUMN expiring_date expiring_date VARCHAR(10) NULL DEFAULT NULL;

-- Modificar la tabla company
ALTER TABLE company
DROP COLUMN website;

-- Modificar tabla user
ALTER TABLE user
CHANGE COLUMN email personal_email VARCHAR(150) NULL DEFAULT NULL,
RENAME TO  data_user;

## Exercici 2
### L'empresa també et sol·licita crear una vista anomenada "InformeTecnico" que contingui la següent informació:
### ID de la transacció. Nom de l'usuari/ària. Cognom de l'usuari/ària. IBAN de la targeta de crèdit usada. Nom de la companyia de la transacció realitzada.
### Assegura't d'incloure informació rellevant de totes dues taules i utilitza àlies per a canviar de nom columnes segons sigui necessari.
### Mostra els resultats de la vista, ordena els resultats de manera descendent en funció de la variable ID de transaction.
-- Para crear la vista solicitada
CREATE VIEW InformeTecnico AS
SELECT transaction.id AS transaction_id, data_user.name, data_user.surname, credit_card.iban, company.company_name
FROM transaction
JOIN data_user ON data_user.id = transaction.user_id
JOIN credit_card ON credit_card.id = transaction.credit_card_id
JOIN company ON company.id = transaction.company_id
ORDER BY transaction_id DESC;

-- Para ver el resultado de la vista creada
SELECT *
FROM InformeTecnico;
