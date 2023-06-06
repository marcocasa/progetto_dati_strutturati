CREATE OR REPLACE FUNCTION public.comuni_soglia_giornaliera(anno integer, indicatore varchar)
    RETURNS TABLE(comune varchar, provincia varchar) 
    LANGUAGE 'plpgsql'

AS $BODY$
BEGIN
	RETURN query
	SELECT distinct(c.nome), p.nome
	FROM comuni as c 
	    JOIN province as p ON p.id_prov = c.id_prov
		JOIN stazioni as s ON s.id_comune = c.id_comune
		JOIN (SELECT ril.nome_stazione
			  FROM (SELECT r.nome_stazione, COUNT(*) as numero_giorni_superamento
					FROM rilevazioni as r JOIN indicatori as i 
							ON i.sigla = r.sigla_indicatore
					WHERE EXTRACT(YEAR from r.data_rilevazione) = $1 
							  and r.sigla_indicatore = $2 
							  and r.valore > i.soglia_media_giornaliera
					GROUP BY r.nome_stazione
						) as ril, indicatori as i
	WHERE i.sigla = $2 and ril.numero_giorni_superamento > i.giorni_superamento) as staz ON staz.nome_stazione = s.nome;

END
$BODY$;

SELECT * FROM comuni_soglia_giornaliera(2020, 'PM10')

