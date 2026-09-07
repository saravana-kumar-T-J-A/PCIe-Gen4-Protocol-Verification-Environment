`include "top.svh"
`include "uvm_macros.svh"

import uvm_pkg::*;
class pcie_pwr_mgmt_seq_item extends uvm_sequence_item;
  rand bit enter_l0s_req, enter_l1_req, exit_lowpower;

  `uvm_object_utils_begin(pcie_pwr_mgmt_seq_item)
    `uvm_field_int(enter_l0s_req, UVM_ALL_ON)
    `uvm_field_int(enter_l1_req,  UVM_ALL_ON)
    `uvm_field_int(exit_lowpower, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "pcie_pwr_mgmt_seq_item");
    super.new(name);
  endfunction
  function string convert2string();
    return $sformatf("l0s=%0d l1=%0d exit=%0d", enter_l0s_req, enter_l1_req, exit_lowpower);
  endfunction
endclass
