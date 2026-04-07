DO $$
BEGIN
    --Teste para ver se funciona
    RAISE NOTICE 'Helô diz: Oiii!';
END;
$$

--Vejamos se deu certo:

DO $$
BEGIN
    RAISE NOTICE 'Helô testa: Deu certo?';
END;
$$