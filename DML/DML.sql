COPY decessi
FROM 'C:\Users\Marco\progetto_dati_strutturati\dataset\decessi\decessi_finale.csv'
DELIMITER ','
CSV Header;


COPY popolazioni
FROM 'C:\Users\Marco\progetto_dati_strutturati\dataset\popolazioni\popolazioni_finale.csv'
DELIMITER ','
CSV HEADER;

COPY stazioni
FROM 'C:\Users\Marco\progetto_dati_strutturati\dataset\stazioni\stazioni_finale.csv'
DELIMITER ','
CSV Header;
UPDATE stazioni SET geom = ST_SETSRID(ST_MakePoint(long, lat),4326);



COPY indicatori
FROM 'C:\Users\Marco\progetto_dati_strutturati\dataset\indicatori\indicatori_finale.csv'
DELIMITER ','
CSV HEADER;


COPY rileva
FROM 'C:\Users\Marco\progetto_dati_strutturati\dataset\rileva\rileva_finale.csv'
DELIMITER ','
CSV HEADER;


COPY rilevazioni
FROM 'C:\Users\Marco\progetto_dati_strutturati\dataset\rilevazioni\rilevazioni_finale.csv'
DELIMITER ','
CSV HEADER;

COPY province
FROM 'C:\Users\Marco\progetto_dati_strutturati\dataset\province\province_finale.csv'
DELIMITER ','
CSV HEADER;

SELECT UpdateGeometrySRID('province', 'geom', 4326);
SELECT UpdateGeometrySRID('comuni', 'geom', 4326);
