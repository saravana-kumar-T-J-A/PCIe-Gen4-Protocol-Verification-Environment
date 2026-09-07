`include "top.svh"
`include "uvm_macros.svh"

import uvm_pkg::*;
class pcie_pwr_mgmt_base_seq extends uvm_sequence#(pcie_pwr_mgmt_seq_item);
  `uvm_object_utils(pcie_pwr_mgmt_base_seq)
  function new(string name = "pcie_pwr_mgmt_base_seq");
    super.new(name);
  endfunction
endclass

// seq_1: L0s entry then immediate wake -- exercises the fast-exit ASPM path
class pcie_pwr_mgmt_l0s_seq extends pcie_pwr_mgmt_base_seq;
  `uvm_object_utils(pcie_pwr_mgmt_l0s_seq)
  function new(string name = "pcie_pwr_mgmt_l0s_seq");
    super.new(name);
  endfunction
  task body();
    pcie_pwr_mgmt_seq_item item;
    `uvm_do_with(item, { enter_l0s_req == 1'b1; enter_l1_req == 1'b0; exit_lowpower == 1'b0; })
    `uvm_do_with(item, { enter_l0s_req == 1'b0; enter_l1_req == 1'b0; exit_lowpower == 1'b1; })
  endtask
endclass

// seq_2: L1 entry then wake -- exercises the slow-exit path (re-enters Recovery)
class pcie_pwr_mgmt_l1_seq extends pcie_pwr_mgmt_base_seq;
  `uvm_object_utils(pcie_pwr_mgmt_l1_seq)
  function new(string name = "pcie_pwr_mgmt_l1_seq");
    super.new(name);
  endfunction
  task body();
    pcie_pwr_mgmt_seq_item item;
    `uvm_do_with(item, { enter_l1_req == 1'b1; enter_l0s_req == 1'b0; exit_lowpower == 1'b0; })
    `uvm_do_with(item, { enter_l1_req == 1'b0; enter_l0s_req == 1'b0; exit_lowpower == 1'b1; })
  endtask
endclass
