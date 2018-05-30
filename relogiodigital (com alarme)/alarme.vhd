library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity alarme is
port (config: in std_logic;
		str_sto: in std_logic;
		set: in std_logic;
		reset: in std_logic;
		alarme_ativado: out std_logic;
		led_modo_conf: out std_logic;
		us_marcado: out integer;
		ds_marcado: out integer;
		um_marcado: out integer;
		dm_marcado: out integer;
		uh_marcado: out integer;
		dh_marcado: out integer);
end alarme;

architecture alarme of alarme is
	
	component regset is
	port (set: in std_logic;
			valoratual_set: in integer;
			valor_set: out integer);
	end component;
	
	component regconf is
		port (config: in std_logic;
		valoratual_conf: in std_logic;
		valor_conf: out std_logic);
	end component;
	
	component regstrsto is
		port (str_sto: in std_logic;
		valoratual_strsto: in integer;
		valor_set: in integer;
		valor_strsto: out integer);
	end component;
	
	component regalarme is
		port (valor_set: in integer;
		alarme_ativo: out std_logic);
	end component;
	
	signal alarme_ativo: std_logic :='0';
	signal valor_set: integer :=0;
	signal valor_strsto: integer :=0;
	signal valoratual_conf: std_logic :='0';
	signal valoratual_strsto: integer :=0;
	signal valoratual_set: integer :=0;
	signal valor_conf: std_logic := '0';
	
	signal um: integer := 0;
	signal dm: integer := 0;
	signal uh: integer := 0;
	signal dh: integer := 0;

	begin
		valoratual_conf <= valor_conf;	
		valoratual_set <= valor_set;
		valoratual_strsto <= valor_strsto;		
		alarme_ativado <= alarme_ativo;
		
		reg_alarme_ativado: regalarme port map(valor_set, alarme_ativo);
		reg_conf: regconf port map(config, valoratual_conf, valor_conf);
		reg_str_sto: regstrsto port map(str_sto, valoratual_strsto, valor_set, valor_strsto); 
		reg_set: regset port map(set, valoratual_set, valor_set); 

		process(valor_conf, valor_set)
		begin
			if(reset='1') then
					us_marcado <= 0;
					ds_marcado <= 0;
					dh_marcado <= 0;
					uh_marcado <= 0;
					dm_marcado <= 0;
					um_marcado <= 0;
			else
				if(valor_conf = '1') then		
					us_marcado <= 0;
					ds_marcado <= 0;
					if(valor_set = 0) then
						dh_marcado <= valor_strsto;
					elsif(valor_set = 1) then
						uh_marcado <= valor_strsto;
					elsif(valor_set = 2) then
						dm_marcado <= valor_strsto;
					elsif(valor_set = 3) then
						um_marcado <= valor_strsto;
					end if;
				end if;
			end if;
		end process;
		
		led_modo_conf <= valor_conf;
		
end alarme;