CREATE OR REPLACE FUNCTION public.num_stazioni_prov_sup_limite_annuo(provincia varchar, indicatore varchar, anno integer)
    RETURNS TABLE(num_stazioni_superamento bigint, num_stazioni_prov bigint) 
    LANGUAGE 'plpgsql'

AS $BODY$
BEGIN
	RETURN query
	SELECT * FROM
		(SELECT COUNT(*) as stazioni_sup_limite_giornaliero
			FROM (SELECT r.nome_stazione, COUNT(*) as numero_giorni_superamento
				  FROM rilevazioni as r JOIN indicatori as i 
						ON i.sigla = r.sigla_indicatore
				  WHERE EXTRACT(YEAR from r.data_rilevazione) = $3
									  and r.sigla_indicatore = $2
									  and r.valore > i.soglia_media_giornaliera
				  GROUP BY r.nome_stazione
								) as ril
				JOIN stazioni as s ON ril.nome_stazione = s.nome
				JOIN comuni as c ON s.id_comune = c.id_comune
				JOIN province as p ON c.id_prov = p.id_prov, indicatori as i
			WHERE p.nome = $1 and i.sigla = $2 and ril.numero_giorni_superamento > i.giorni_superamento) as stazioni_sup_limite_giornaliero,
		(SELECT COUNT(*) as num_stazioni_provincia
			FROM province as p
				JOIN comuni as c ON c.id_prov = p.id_prov
				JOIN stazioni as s ON s.id_comune = c.id_comune
		    WHERE p.nome = $1) as num_stazioni_provincia; 
END
$BODY$;


			  


SELECT * FROM num_stazioni_prov_sup_limite_annuo('Bari', 'PM10', 2020)

