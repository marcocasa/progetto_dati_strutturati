ALTER TABLE comuni_finale RENAME TO comuni;
ALTER TABLE province_finale RENAME TO province;


alter table comuni drop column gid;
alter table comuni add constraint comuni_pkey primary key (id_comune);

alter table province drop column gid;
alter table province add constraint province_pkey primary key (id_prov);


Alter table comuni alter column id_comune type integer;
Alter table comuni alter column id_prov type integer;

ALTER TABLE comuni ADD FOREIGN KEY (id_prov) REFERENCES province(id_prov) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE comuni 
ALTER COLUMN geom TYPE geometry(MULTIPOLYGON, 4326) USING ST_Transform(ST_SetSRID(geom,32632),4326);


ALTER TABLE province 
ALTER COLUMN geom TYPE geometry(MULTIPOLYGON, 4326) USING ST_Transform(ST_SetSRID(geom,32632),4326);

CREATE TABLE decessi(
	id_decessi SERIAL PRIMARY KEY,
	nome_malattia VARCHAR(100) NOT NULL,
	numero_decessi_maschi INT NOT NULL,
	numero_decessi_femmine INT NOT NULL,
	anno INT NOT NULL,
	id_prov INT NOT NULL,
	FOREIGN KEY (id_prov) REFERENCES province(id_prov)
	ON UPDATE CASCADE
	ON DELETE CASCADE
);


CREATE TABLE popolazioni(
	id_popolazioni SERIAL PRIMARY KEY,
	numero_maschi INT NOT NULL,
	numero_femmine INT NOT NULL,
	anno INT NOT NULL,
	id_comune INT NOT NULL,
	FOREIGN KEY (id_comune) REFERENCES comuni(id_comune)
	ON UPDATE CASCADE
	ON DELETE CASCADE
);


CREATE TABLE stazioni(
	nome VARCHAR(100) PRIMARY KEY,
	geom GEOMETRY(Point, 4326),
	id_comune INT NOT NULL,
	lat numeric NOT NULL,
	long numeric NOT NULL,
	FOREIGN KEY (id_comune) REFERENCES comuni(id_comune)
	ON UPDATE CASCADE
	ON DELETE CASCADE
);


CREATE TABLE indicatori(
	sigla VARCHAR(10) PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	soglia_media_giornaliera FLOAT NOT NULL,
	giorni_superamento INT NOT NULL,
	soglia_media_annuale FLOAT NOT NULL
);

CREATE TABLE rileva(
	sigla_indicatore VARCHAR(10),
	nome_stazione VARCHAR(100),
	PRIMARY KEY(sigla_indicatore, nome_stazione),
	FOREIGN KEY (sigla_indicatore) REFERENCES indicatori(sigla),
	FOREIGN KEY (nome_stazione) REFERENCES stazioni(nome)
	ON UPDATE CASCADE
	ON DELETE CASCADE
);

CREATE TABLE rilevazioni(
	id_rilevazioni SERIAL PRIMARY KEY,
	data_rilevazione DATE NOT NULL,
	valore FLOAT,
	sigla_indicatore VARCHAR(10),
	nome_stazione VARCHAR(100),
	FOREIGN KEY (sigla_indicatore) REFERENCES indicatori(sigla),
	FOREIGN KEY (nome_stazione) REFERENCES stazioni(nome)
	ON UPDATE CASCADE
	ON DELETE CASCADE
);

SELECT UpdateGeometrySRID('province', 'geom', 4326);
SELECT UpdateGeometrySRID('comuni', 'geom', 4326);