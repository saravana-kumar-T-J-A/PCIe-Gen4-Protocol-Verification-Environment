`include "top.svh"
`include "uvm_macros.svh"

import uvm_pkg::*;
class pcie_pwr_mgmt_sequencer extends uvm_sequencer#(pcie_pwr_mgmt_seq_item);
  `uvm_component_utils(pcie_pwr_mgmt_sequencer)
  function new(string name = "pcie_pwr_mgmt_sequencer", uvm_component parent);
    super.new(name, parent);
  endfunction
endclass
