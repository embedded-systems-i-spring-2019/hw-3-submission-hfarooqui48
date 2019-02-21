Library IEEE;
use IEEE.STD_Logic_1164.all;

entity mux_4t1 is
    port( A,B,C,D : in std_logic_vector(7 downto 0);
            SEL: in std_logic_vector(1 downto 0);
             Y: out std_logic_vector(7 downto 0));
end mux_4t1;

architecture my_mux_4t1 of mux_4t1 is
begin
    with SEL select
        Y <= A when "00",
         B when "01",
         C when "10",
         D when "11",
      (others=> '0') when others;
end my_mux_4t1;

Library IEEE;
use IEEE.STD_Logic_1164.all;

entity decoder_1t2 is 
    port( A :in std_logic;
          Y :out std_logic_vector(1 downto 0));
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
    port ( DS,CLK : in std_logic;
            SEL: in std_logic_vector(1 downto 0);
            D1,D2,D3         : in std_logic_vector(7 downto 0);
                RA,RB       : inout std_logic_vector(7 downto 0));
end rtl_ckt;

architecture my_rtl_ckt of rtl_ckt is

component decoder_1t2
    port( A :in std_logic;
          Y:out std_logic_vector(1 downto 0));
end component;          

component regs
   port(inreg : in std_logic_vector(7 downto 0);
        CLK,ldreg: in std_logic;
        outreg: inout std_logic_vector(7 downto 0));
   end component;

 component mux_4_1 
   port( A,B,C,D : in std_logic_vector(7 downto 0);
         SEL: in std_logic_vector(1 downto 0);
         Y: out std_logic_vector(7 downto 0));
    end component;

    signal mux_result : std_logic_vector(7 downto 0);
    signal lda: std_logic;
    signal ldb: std_logic;
    signal raout: std_logic_vector(7 downto 0);

begin
    dec: decoder_1t2
    port map( A=>DS,
              Y(0)=>lda,
              Y(1)=>ldb);
    r1:  regs
    port map( inreg=>mux_result,
                CLK=>CLK,
                ldreg=>lda,
                outreg=>RA);
                
    r2:  regs
    port map( inreg=>RA,
                CLK=>CLK,
                ldreg=>ldb,
                outreg=>RB);                

    m1: mux_4_1
    port map(A=>RB,
             B=>D1,
             C=>D2,
             D=>D3,
             SEL=>SEL,
             Y=>mux_result);
end my_rtl_ckt;