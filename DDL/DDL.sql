CREATE TABLE decessi(
	id_decessi INT PRIMARY KEY,
	nome_malattia VARCHAR(100) NOT NULL,
	numero_decessi_maschi INT NOT NULL,
	numero_decessi_femmine INT NOT NULL,
	anno INT NOT NULL,
	id_provincia INT NOT NULL,
	FOREIGN KEY (id_provincia) REFERENCES province(id_prov)
);


CREATE TABLE comuni(
	id_comune INT PRIMARY KEY,
	nome VARCHAR(80) NOT NULL,
	geom GEOMETRY NOT NULL,
	id_provincia INT NOT NULL,
	FOREIGN KEY (id_provincia) REFERENCES province(id_prov)
);


CREATE TABLE popolazioni(
	id_popolazioni INT PRIMARY KEY,
	numero_maschi INT NOT NULL,
	numero_femmine INT NOT NULL,
	anno INT NOT NULL,
	id_comune INT NOT NULL,
	FOREIGN KEY (id_comune) REFERENCES comuni(id_comune)
);


CREATE TABLE stazioni(
	nome VARCHAR(100) PRIMARY KEY,
	geom GEOMETRY NOT NULL,
	id_comune INT NOT NULL,
	FOREIGN KEY (id_comune) REFERENCES comuni(id_comune)
);


CREATE TABLE indicatori(
	sigla VARCHAR(10) PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	soglia_media_giornaliera INT NOT NULL,
	giorni_superamento INT NOT NULL,
	soglia_media_annuale FLOAT NOT NULL
);

CREATE TABLE rileva(
	sigla_indicatore VARCHAR(10),
	nome_stazione VARCHAR(100),
	PRIMARY KEY(sigla_indicatore, nome_stazione),
	FOREIGN KEY (sigla_indicatore) REFERENCES indicatori(sigla),
	FOREIGN KEY (nome_stazione) REFERENCES stazioni(nome)
);

CREATE TABLE rilevazioni(
	id_rilevazioni INT PRIMARY KEY,
	data_rilevazione DATE NOT NULL,
	valore INT,
	sigla_indicatore VARCHAR(10),
	nome_stazione VARCHAR(100),
	FOREIGN KEY (sigla_indicatore) REFERENCES indicatori(sigla),
	FOREIGN KEY (nome_stazione) REFERENCES stazioni(nome)
);