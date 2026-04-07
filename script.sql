/* Enunciado 3 - Sobrevivência em função do gênero
Escreva um cursor com query dinâmica que mostra o número de passageiros
sobreviventes dentre as mulheres (Sex = 'female'). Escreva um condicional para que, se
não existir nenhuma, o valor -1 seja exibido.
 */

DO $$
DECLARE
	cur_titanic REFCURSOR;
	v_titanic VARCHAR(200);
	v_sex VARCHAR(200) := 'female';
	v_tabela VARCHAR(200) := 'tb_titanic';
    v_survived INT := 1;
    sobreviveram INT := 0;
BEGIN
	OPEN cur_titanic FOR EXECUTE
	format('SELECT survived FROM %s WHERE sex = $1 AND survived = 1', v_tabela) USING v_sex;
	LOOP
		FETCH cur_titanic INTO v_titanic;
		EXIT WHEN NOT FOUND;
            sobreviveram := sobreviveram + 1;
	END LOOP;
    IF sobreviveram >= 1 THEN
        RAISE NOTICE 'A quantidade de mulheres sobreviventes é: %', sobreviveram;
    ELSE
        RAISE NOTICE '-1';
    END IF;
    --RAISE NOTICE 'A quantidade de mulheres sobreviventes é: %', sobreviveram;
	CLOSE cur_titanic;
END;
$$
