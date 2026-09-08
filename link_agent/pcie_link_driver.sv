`include "top.svh"
`include "uvm_macros.svh"

import uvm_pkg::*;
class pcie_link_driver extends uvm_driver#(pcie_link_seq_item);
  `uvm_component_utils(pcie_link_driver)
  virtual pcie_if vif;
  pcie_link_agent_config agt_cnfg;

  `define LDRIV_IF vif.LINK_DRIVER_MODPORT.link_driver_cb

  function new(string name = "pcie_link_driver", uvm_component parent);
    super.new(name, parent);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(pcie_link_agent_config)::get(this, "", "agt_cnfg", agt_cnfg))
      `uvm_fatal(get_full_name(), "link driver config not found")
  endfunction
  function void connect_phase(uvm_phase phase);
    vif = agt_cnfg.vif;
  endfunction

  extern task drive_reset();
  extern task run_phase(uvm_phase phase);
  extern task drive(pcie_link_seq_item req);
endclass

task pcie_link_driver::drive_reset();
  `LDRIV_IF.dll_dllp_valid <= 1'b0;
endtask

task pcie_link_driver::run_phase(uvm_phase phase);
  drive_reset();
  forever begin
    seq_item_port.get_next_item(req);
    drive(req);
    seq_item_port.item_done();
  end
endtask

// injects explicit NAK DLLPs (out-of-band from the DUT's own ACK/NAK
// generation) to exercise the replay-buffer retransmit path in pcie_dll_engine.v
task pcie_link_driver::drive(pcie_link_seq_item req);
  @(`LDRIV_IF);
  `LDRIV_IF.dll_dllp_valid <= req.dllp_valid;
  `LDRIV_IF.dll_dllp_type  <= req.dllp_type;
  `LDRIV_IF.dll_dllp_seq   <= req.dllp_seq;
  @(`LDRIV_IF);
  `LDRIV_IF.dll_dllp_valid <= 1'b0;
  `uvm_info("LINK_DRV", $sformatf("drove %s", req.convert2string()), UVM_LOW)
endtask
