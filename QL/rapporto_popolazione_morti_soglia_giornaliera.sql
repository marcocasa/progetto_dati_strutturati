CREATE OR REPLACE FUNCTION public.rapporto_popolazione_morti_soglia_giornaliera(anno integer, indicatore varchar)
    RETURNS TABLE(provincia varchar, rapporto_popolazione_morti float) 
    LANGUAGE 'plpgsql'

AS $BODY$
BEGIN
	RETURN query
	SELECT distinct(p.nome), CAST(pop.popolazione as FLOAT) / CAST(d.numero_morti as FLOAT) as rapporto_popolazione_morti
	FROM province as p 
		JOIN (
			SELECT  d.id_prov, SUM(d.numero_decessi_maschi)+SUM(d.numero_decessi_femmine) as numero_morti
			FROM decessi as d
			WHERE d.anno = $1
			GROUP BY id_prov) as d
		ON p.id_prov = d.id_prov
		JOIN (SELECT prov.id_prov, SUM(p.numero_femmine)+SUM(p.numero_maschi) as popolazione
			  FROM popolazioni as p 
				JOIN comuni as c ON p.id_comune = c.id_comune 
				JOIN province as prov ON prov.id_prov = c.id_prov
			  WHERE p.anno = $1
			  GROUP BY prov.id_prov) as pop ON pop.id_prov = p.id_prov 
		JOIN comuni as c ON p.id_prov = c.id_prov
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
			  WHERE i.sigla = $2 and ril.numero_giorni_superamento > i.giorni_superamento) as staz ON staz.nome_stazione = s.nome 
	ORDER BY rapporto_popolazione_morti ASC;

END
$BODY$;

SELECT * FROM rapporto_popolazione_morti_soglia_giornaliera(2019, 'PM2.5')

