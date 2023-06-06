CREATE OR REPLACE FUNCTION public.rilevazione_massima_provincia(indicatore varchar, anno integer)
    RETURNS TABLE(provincia varchar, valore_massimo double precision) 
    LANGUAGE 'plpgsql'

AS $BODY$
BEGIN
	RETURN query
	SELECT p.nome, prov.massimo_valore
	FROM(
		SELECT p.id_prov, MAX(valore) as massimo_valore 
		FROM province as p
			JOIN comuni as c ON c.id_prov = p.id_prov
			JOIN stazioni as s ON s.id_comune = c.id_comune
			JOIN rilevazioni as r ON r.nome_stazione = s.nome
		WHERE r.sigla_indicatore = $1 and EXTRACT(YEAR from r.data_rilevazione) = $2
		GROUP BY p.id_prov) as prov 
	 JOIN province as p ON p.id_prov = prov.id_prov
	 ORDER BY prov.massimo_valore DESC;
END
$BODY$;

SELECT * FROM rilevazione_massima_provincia('PM2.5', 2020)

