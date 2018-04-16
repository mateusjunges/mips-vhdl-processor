------------------------------------------------------
-- Bloco de instruções da memória
-- 
-- Contém todas as intruções que serão executadas.
-- 
-- 
-- Inicialmente este componente le o arquivo 'instructions.txt'
-- e salva ele em um segundo array
-- 
-- Pega um endereço de 32bits e retorna a instrução daquele endereço 
------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use STD.textio.all; -- Required for freading a file

entity instruction_memory is
	port (
		read_address: in STD_LOGIC_VECTOR (31 downto 0);
		instruction, last_instr_address: out STD_LOGIC_VECTOR (31 downto 0)
	);
end instruction_memory;


architecture behavioral of instruction_memory is	  

    -- 128 byte instruction memory (32 rows * 4 bytes/row)
    type mem_array is array(0 to 31) of STD_LOGIC_VECTOR (31 downto 0);
    signal data_mem: mem_array := (
        "00000000000000000000000000000000", -- initialize data memory
        "00000000000000000000000000000000", -- mem 1
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000", 
        "00000000000000000000000000000000", -- mem 10 
        "00000000000000000000000000000000", 
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",  
        "00000000000000000000000000000000", -- mem 20
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000", 
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000",
        "00000000000000000000000000000000", 
        "00000000000000000000000000000000", -- mem 30
        "00000000000000000000000000000000"
    );

    begin

    -- Processo para ler intruções para a memoria
    process 
        file file_pointer : text;
        variable line_content : string(1 to 32);
        variable line_num : line;
        variable i: integer := 0;
        variable j : integer := 0;
        variable char : character:='0'; 
    
        begin
        -- Abre o arquivo de instruções e le
        file_open(file_pointer, "instructions.txt", READ_MODE);
        -- Lê até o fim do arquivo 
        while not endfile(file_pointer) loop
            readline(file_pointer,line_num); -- Le uma linha do arquivo
            READ(line_num,line_content); -- Transforma a string em linha 
            -- Converte cada caracter da string em um bit e salva na memoria
            for j in 1 to 32 loop        
                char := line_content(j);
                if(char = '0') then
                    data_mem(i)(32-j) <= '0';
                else
                    data_mem(i)(32-j) <= '1';
                end if; 
            end loop;
            i := i + 1;
        end loop;
        if i > 0 then
            last_instr_address <= std_logic_vector(to_unsigned((i-1)*4, last_instr_address'length));
        else
            last_instr_address <= "00000000000000000000000000000000";
        end if;

        file_close(file_pointer); -- Close the file 
        wait; 
    end process;

    -- Desde que os registradores são multiplos de 4 bits, podemos ignorar os ultimos dois
    instruction <= data_mem(to_integer(unsigned(read_address(31 downto 2))));

end behavioral;