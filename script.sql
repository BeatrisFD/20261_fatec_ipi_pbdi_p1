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

/* Enunciado 4 - Tarifa versus embarque
Dentre os passageiros que pagaram tarifa (Fare) maior que 50, quantos embarcaram em
Cherbourg (Embarked = 'C')? Escreva um cursor vinculado que exiba esse valor. */

DO $$
DECLARE
	--Declaracao
	cur_titanic CURSOR FOR 
	SELECT fare, embarked FROM tb_titanic ;
	tupla RECORD;
	resultado INT := 0;
BEGIN
	--Abertura
	OPEN cur_titanic;
	--Recuperacao
	FETCH cur_titanic INTO tupla;
	WHILE FOUND
	LOOP
        IF tupla.fare > 50 AND tupla.embarked = 'C' THEN
            resultado := resultado + 1;
        END IF;
		FETCH cur_titanic INTO tupla;
	END LOOP;
	--Fechamento
	CLOSE cur_titanic;
	RAISE NOTICE '%', resultado;
END;
$$

--Enunciado 5 Limpeza de valores NULL

DO $$
DECLARE
cur_delete REFCURSOR;
tupla RECORD;
BEGIN
OPEN cur_delete SCROLL FOR
SELECT
*
FROM
tb_titanic;
LOOP
FETCH cur_delete INTO tupla;
EXIT WHEN NOT FOUND;
IF tupla.cabin IS NULL THEN
RAISE NOTICE '%', tupla.cabin;
DELETE FROM tb_titanic WHERE CURRENT OF cur_delete;
END IF;
END LOOP;

LOOP
FETCH BACKWARD FROM cur_delete INTO tupla;
EXIT WHEN NOT FOUND;
RAISE NOTICE '%', tupla;
END LOOP;
CLOSE cur_delete;
END;
$$



--Enunciado 2 - Sobrevivência em função da classe social
DO $$
DECLARE

cur_nomes_passageiro REFCURSOR;
v_classe INT := 1;
v_survived VARCHAR(200);
v_nome_tabela VARCHAR(200) := 'tb_titanic';
contador INT := 0;
BEGIN

OPEN cur_nomes_passageiro FOR EXECUTE
format
(
'
SELECT
Survived
FROM
%s
WHERE pclass = $1
'
,
v_nome_tabela
)USING v_classe;
LOOP
FETCH cur_nomes_passageiro INTO v_survived;
EXIT WHEN NOT FOUND;
RAISE NOTICE '%', v_survived;
IF v_classe = 1 THEN
    contador := contador +1;
END IF;
END LOOP;
RAISE NOTICE 'Numero: %', contador;
CLOSE cur_nomes_passageiro;

END;
$$