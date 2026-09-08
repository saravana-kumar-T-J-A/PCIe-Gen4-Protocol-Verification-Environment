`include "top.svh"
`include "uvm_macros.svh"

import uvm_pkg::*;
class pcie_link_seq_item extends uvm_sequence_item;
  rand bit               dllp_valid;
  rand bit [1:0]         dllp_type;   // 0=ACK 1=NAK
  rand bit [11:0]        dllp_seq;

  `uvm_object_utils_begin(pcie_link_seq_item)
    `uvm_field_int(dllp_valid, UVM_ALL_ON)
    `uvm_field_int(dllp_type,  UVM_ALL_ON)
    `uvm_field_int(dllp_seq,   UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "pcie_link_seq_item");
    super.new(name);
  endfunction
  function string convert2string();
    return $sformatf("dllp_valid=%0d type=%0d seq=%0d", dllp_valid, dllp_type, dllp_seq);
  endfunction
endclass
