CREATE OR REPLACE FUNCTION public.popolazione_comuni(anno integer)
    RETURNS TABLE(comune varchar, popolazione_comune integer, provincia varchar) 
    LANGUAGE 'plpgsql'

AS $BODY$
BEGIN
	RETURN query
	SELECT c.nome, pop.numero_maschi+pop.numero_femmine as popolazione, p.nome
	FROM comuni as c 
	    JOIN province as p ON p.id_prov = c.id_prov
		JOIN popolazioni as pop ON c.id_comune = pop.id_comune
		WHERE pop.anno = $1
	ORDER BY popolazione DESC LIMIT(25);
END
$BODY$;

SELECT * FROM popolazione_comuni(2020)

