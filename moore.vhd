LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_unsigned.all;

ENTITY moore IS
PORT(
	clk : in std_logic;
	rst : in std_logic;
	entrada : in std_logic_vector(1 DOWNTO 0) := "11"; -- Recordar que el estado de no presionado o apagado es 1 en la tarjeta usada y encendido es 0.
	salida : out std_logic_vector(1 DOWNTO 0) := "11"; -- Recordar que la tarjeta usada enciende leds al mandar 0s y los apaga al mandar 1s
	selector : out std_logic_vector(3 downto 0);
	segmentos: out std_logic_vector(6 downto 0)
);
END ENTITY;

ARCHITECTURE moore_ar OF moore IS
	-- MAQUINA DE moore
	TYPE moore_type IS (S0, S1, S2, S3, S4);
	SIGNAL estado_act : moore_type;

	SIGNAL numero_to_d7s : INTEGER RANGE 9999 DOWNTO 0 := 0;
	
	COMPONENT display7s IS
	PORT(
		clk_prin_d7s : in std_logic;
		numero_d7s : in INTEGER RANGE 9999 DOWNTO 0;
		selector_d7s : out std_logic_vector;
		segmentos_d7s: out std_logic_vector
	);
	END COMPONENT;
	
	-- INICIA ARQUITECTURA DE moore
	BEGIN
	
		Display: display7s PORT MAP(clk, numero_to_d7s, selector, segmentos);
	
		DetectaEntrada: PROCESS(clk, rst)
		VARIABLE salida_tmp : std_logic_vector (1 downto 0) := "00";
		VARIABLE estado_sig : moore_type := S0;
		VARIABLE entrada_n : std_logic_vector(1 DOWNTO 0) := "11";
		BEGIN
			IF (rst = '0') THEN
				estado_act <= S0;
				salida <= "11"; -- Apaga leds
			ELSIF rising_edge(clk) THEN
				entrada_n := NOT entrada; -- SE USAN LAS ENTRADAS NEGADAS POR LAS CARACTERISTICAS DE LA TARJETA
				CASE estado_act IS
					WHEN S0 =>
						CASE entrada_n IS
							WHEN "01" => estado_sig := S1;
							WHEN "10" => estado_sig := S0;
							WHEN OTHERS => estado_sig := S0; -- Es buena práctica dejar por default el mismo estado para cualquier entrada no registrada.
						END CASE;
					WHEN S1 =>
						CASE entrada_n IS
							WHEN "00" => estado_sig := S3;
							WHEN "11" => estado_sig := S2;
							WHEN OTHERS => estado_sig := S1;
						END CASE;
					WHEN S2 =>
						CASE entrada_n IS
							WHEN "01" => estado_sig := S4;
							WHEN "10" => estado_sig := S2;
							WHEN OTHERS => estado_sig := S2;
						END CASE;
					WHEN S3 =>
						CASE entrada_n IS
							WHEN "01" => estado_sig := S1;
							WHEN "10" => estado_sig := S4;
							WHEN OTHERS => estado_sig := S3;
						END CASE;
					WHEN S4 =>
						CASE entrada_n IS
							WHEN "00" => estado_sig := S0;
							WHEN OTHERS => estado_sig := S4;
						END CASE;
					WHEN OTHERS => estado_sig := S0;
				END CASE;
				
				IF estado_act = S0 THEN
						salida_tmp := "00";
				ELSIF estado_act = S1 THEN
					salida_tmp := "11";
				ELSIF estado_act = S2 THEN
					salida_tmp := "01";
				ELSIF estado_act = S3 THEN
					salida_tmp := "00";
				ELSIF estado_act = S4 THEN
					salida_tmp := "11";
				END IF;
				
				salida <= NOT salida_tmp; -- NECESARIO INVERTIR, POR FUNCIONAMIENTO DEL FPGA
				estado_act <= estado_sig;
				
			END IF;
		END PROCESS;
		
		MuestraEstado: PROCESS(estado_act)
		BEGIN
			CASE estado_act IS
				WHEN S0 => numero_to_d7s <= 0;
				WHEN S1 => numero_to_d7s <= 1;
				WHEN S2 => numero_to_d7s <= 2;
				WHEN S3 => numero_to_d7s <= 3;
				WHEN S4 => numero_to_d7s <= 4;
				WHEN OTHERS => numero_to_d7s <= 0;
			END CASE;
		END PROCESS;

END moore_ar;