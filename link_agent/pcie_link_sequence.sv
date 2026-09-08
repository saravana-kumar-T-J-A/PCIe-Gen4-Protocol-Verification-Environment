`include "top.svh"
`include "uvm_macros.svh"

import uvm_pkg::*;
class pcie_link_base_seq extends uvm_sequence#(pcie_link_seq_item);
  `uvm_object_utils(pcie_link_base_seq)
  function new(string name = "pcie_link_base_seq");
    super.new(name);
  endfunction
endclass

// seq_1: inject a NAK to force a replay -- checks the DLL replay buffer
// retransmits the correct (un-ACKed) sequence number
class pcie_link_nak_seq extends pcie_link_base_seq;
  `uvm_object_utils(pcie_link_nak_seq)
  rand bit [11:0] nak_seq;
  function new(string name = "pcie_link_nak_seq");
    super.new(name);
  endfunction
  task body();
    pcie_link_seq_item item;
    `uvm_do_with(item, { dllp_valid == 1'b1; dllp_type == 2'b01; dllp_seq == local::nak_seq; })
  endtask
endclass
