LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY contador IS GENERIC(
	clk_frec : INTEGER := 50_000_000 -- Frecuencia del reloj en Hz
);
PORT(
	salida_clk_d7s: out std_logic; -- Senyal de salida con divisor de frecuencia para display de 7 segmentos
	clk_in_d7s : in std_logic -- Senyal de reloj
	--rst : in std_logic -- Senyal de reset
);
END ENTITY;

ARCHITECTURE a_contador OF contador IS
	--SIGNAL cont : INTEGER RANGE 0 TO (clk_frec/2)-1 := 0 ;
	SIGNAL conteo_d7s : INTEGER RANGE 0 TO 99_999 :=0; -- Contador / Reloj para display de 7 segmentos
	SIGNAL salida_d7s : std_logic := '0';
	BEGIN
		DivisorFrecuencia : PROCESS(clk_in_d7s) --,rst)
			BEGIN
				IF (rising_edge(clk_in_d7s)) THEN		
					IF(conteo_d7s = 99_999) THEN
						conteo_d7s <= 0;
						salida_d7s <= not salida_d7s;
					ELSE
						conteo_d7s <= conteo_d7s + 1;
					END IF;
				END IF;
			END PROCESS;
	salida_clk_d7s <= salida_d7s;
	END a_contador;
