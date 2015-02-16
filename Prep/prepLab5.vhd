library ieee;
use ieee.std_logic_1164.all;

entity prepLab5 is
end prepLab5;

architecture behavioral of prepLab5 is

begin
process
variable a: std_logic_vector(7 downto 0);
variable b: std_logic_vector(7 downto 0);
begin
  a := "01010101";
  b := "10101010";
  assert not (a = b)
  report "Is the expected output.";
  a := b;
  assert a = b
  report "Is not the expected output.";
  assert false
  report "Test terminated"
  severity failure;
end process;
end behavioral;
