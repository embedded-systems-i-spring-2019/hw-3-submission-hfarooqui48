Library IEEE;
use IEEE.STD_Logic_1164.all;

entity mux_2t1 is
    port( A,B : in std_logic_vector(7 downto 0);
            SEL: in std_logic;
               Y: out std_logic_vector(7 downto 0));
end mux_2t1;
architecture my_mux_2t1 of mux_2t1 is

begin
    with SEL select
        Y<=B when '1',
         A when '0',
        (others=> '0') when others;
end my_mux_2t1;

Library IEEE;
use IEEE.STD_Logic_1164.all;

entity regs is
    port( inreg : in std_logic_vector(7 downto 0);
            CLK,ldreg: in std_logic;
               outreg: out std_logic_vector(7 downto 0));

end regs;

architecture my_regs of regs is 

begin
    process(CLK)
        begin
            if (rising_edge(CLK)) then
                if (ldreg='1') then
                     outreg<=inreg;
                end if;
            end if;
         end process    ;
end my_regs;

Library IEEE;
use IEEE.STD_Logic_1164.all;

entity decoder_1t2 is 
    port( A :in std_logic;
          Y:out std_logic_vector(1 downto 0));
end decoder_1t2;

architecture my_decoder_1t2 of decoder_1t2 is

begin
    with A select
        Y<="01" when '0',
            "10" when '1',
        "0" when others;
end my_decoder_1t2;    

Library IEEE;
use IEEE.STD_Logic_1164.all;

entity rtl_ckt is 

    port ( SEL1,SEL2,CLK : in std_logic;
            A,B,C           : in std_logic_vector(7 downto 0);
            RAP,RBP       : inout std_logic_vector(7 downto 0));
              
end rtl_ckt;

architecture my_rtl_ckt of rtl_ckt is

component regs
        port(inreg : in std_logic_vector(7 downto 0);
            CLK,ldreg: in std_logic;
               outreg: inout std_logic_vector(7 downto 0));
     end component;

 component mux_2t1 
     port( A,B : in std_logic_vector(7 downto 0);
            SEL: in std_logic;
               Y: out std_logic_vector(7 downto 0));
    end component;

component decoder_1t2
    port( A :in std_logic;
          Y:out std_logic_vector(1 downto 0));
    end component;           

     signal d1_result: std_logic_vector (1 downto 0);
    signal m1_result:   std_logic_vector(7 downto 0);
   
begin
    m1:mux_2t1
        port map(A=>B,
                B=>A,
                SEL=>SEL1,
                Y=>m1_result);
                
    r1: regs
        port map(inreg=>m1_result,
                CLK=>CLK,
                ldreg=>d1_result(1),
                outreg=>RAP);
        
    r2: regs
        port map(inreg=>C,
                CLK=>CLK,
                ldreg=>d1_result(0),
                outreg=>RBP);

    dec1: decoder_1t2
        port map(A=>SEL2,
                    Y(0)=> d1_result(0),
                    Y(1)=>d1_result(1));    
end my_rtl_ckt;                       