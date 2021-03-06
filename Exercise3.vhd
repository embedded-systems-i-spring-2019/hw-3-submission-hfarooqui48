library IEEE;
use IEEE.STD_Logic_1164.all;

entity mux_2t1 is
    port( A,B : in std_logic_vector(7 downto 0);
            SEL: in std_logic;
               Y: out std_logic_vector(7 downto 0));
end mux_2t1;

architecture my_mux_2t1 of mux_2t1 is

begin
    with SEL select
        Y <=B when '1',
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

entity rtl_ckt is 
    port ( LDA,LDB,S0,S1,CLK : in std_logic;
            X,Y : in std_logic_vector(7 downto 0);
             RB : inout std_logic_vector(7 downto 0));
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

    signal mux1_result : std_logic_vector(7 downto 0);
    signal mux2_result : std_logic_vector(7 downto 0);
    signal r1_result : std_logic_vector(7 downto 0);
begin
    mux1:mux_2t1
        port map(A=>RB,
                B=>X,
                SEL=>S1,
                Y=>mux1_result);
    ra: regs
        port map(inreg=>mux1_result,
                CLK=>CLK,
                ldreg=>LDA,
                outreg=>r1_result);
    mux2: mux_2t1
        port map(A=>Y,
                B=>r1_result,
                SEL=>S0,
                Y=>mux2_result);                                 
    r2: regs
        port map(inreg=>mux2_result,
                CLK=>CLK,
                ldreg=>LDB,
                outreg=>RB);
end my_rtl_ckt;           