`include "top.svh"
`include "uvm_macros.svh"

import uvm_pkg::*;
class pcie_link_sequencer extends uvm_sequencer#(pcie_link_seq_item);
  `uvm_component_utils(pcie_link_sequencer)
  function new(string name = "pcie_link_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction
endclass
