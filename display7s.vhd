LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;

ENTITY display7s IS
PORT(
	clk_prin_d7s : in std_logic;
	numero_d7s : in integer RANGE 9999 DOWNTO 0;
	selector_d7s : out std_logic_vector(3 downto 0);
	segmentos_d7s: out std_logic_vector(6 downto 0)
);
END ENTITY;

ARCHITECTURE display7s_ar OF display7s IS
	-- RELOJ CONTADOR PARA DISPLAY DE 7 SEGMENTOS
	SIGNAL clk_d7s : std_logic;
	
	SIGNAL cont_display : std_logic_vector(1 downto 0) := "00";
	SIGNAL selector_mostrar : std_logic_vector(3 downto 0) := "0000";
	SIGNAL Num1,Num2,Num3,Num4 : std_logic_vector(6 downto 0) := "0000000";
	--SIGNAL anyos : integer RANGE 1950 TO 2050 := 1950;
	SIGNAL millares : integer RANGE 0 TO 9 := 0;
	SIGNAL centenas : integer RANGE 0 TO 9 := 0;
	SIGNAL decenas : integer RANGE 0 TO 9 := 0;
	SIGNAL unidades : integer RANGE 0 TO 9 := 0;
	
	-- Contador / Reloj para display de 7 segmentos
	COMPONENT contador is
	PORT(
		salida_clk_d7s: out std_logic;
		clk_in_d7s : in std_logic
	);
	END COMPONENT;
	
BEGIN
	-- MAPEO PARA USAR EL COMPONENTE contador
	Contador_d7s: contador PORT MAP(clk_d7s, clk_prin_d7s);

	CambiaDisplay: PROCESS(clk_d7s)
	BEGIN
		IF rising_edge(clk_d7s) THEN
			cont_display <= cont_display + 1;
		END IF;
	END PROCESS;
	
	MuestraDisplay: PROCESS(cont_display)
	BEGIN
		case cont_display is
			when "00" => selector_mostrar <= "1110";
			when "01" => selector_mostrar <= "1101";
			when "10" => selector_mostrar <= "1011";
			when "11" => selector_mostrar <= "0111";
			when others => selector_mostrar <= "1111";
		end case;
		
		case cont_display is
			when "00" => segmentos_d7s <= Num4;
			when "01" => segmentos_d7s <= Num3;
			when "10" => segmentos_d7s <= Num2;
			when "11" => segmentos_d7s <= Num1;
			when others => segmentos_d7s <= Num1;
		end case;
	END PROCESS;
	
	MuestraNumero : PROCESS(numero_d7s)
	
	FUNCTION DecimalSegmento (Digito : INTEGER RANGE 0 to 9) RETURN std_logic_vector IS
		VARIABLE RETORNO : std_logic_vector(6 downto 0) := "1111111";
		BEGIN
			CASE Digito IS
				WHEN 0 => RETORNO := "1000000";
				WHEN 1 => RETORNO := "1111001";
				WHEN 2 => RETORNO := "0100100";
				WHEN 3 => RETORNO := "0110000";
				WHEN 4 => RETORNO := "0011001";
				WHEN 5 => RETORNO := "0010010";
				WHEN 6 => RETORNO := "0000010";
				WHEN 7 => RETORNO := "1111000";
				WHEN 8 => RETORNO := "0000000";
				WHEN 9 => RETORNO := "0011000";
				WHEN OTHERS => RETORNO := "1111111";
			END CASE;
			RETURN RETORNO;
		END FUNCTION;
		
	BEGIN
	
		millares <= numero_d7s/1000;
		centenas <= (numero_d7s-(millares*1000))/100;
		decenas  <= (numero_d7s-(millares*1000)-(centenas*100))/10;
		unidades <= numero_d7s-(millares*1000)-(centenas*100) - (decenas*10);
		
		Num4 <= DecimalSegmento(millares);
		Num3 <= DecimalSegmento(centenas);
		Num2 <= DecimalSegmento(decenas);
		Num1 <= DecimalSegmento(unidades);
		
	END PROCESS;
	
	
	selector_d7s <= selector_mostrar;

END display7s_ar;