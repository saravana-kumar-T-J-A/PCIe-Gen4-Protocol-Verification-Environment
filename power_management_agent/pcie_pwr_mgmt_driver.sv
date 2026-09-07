`include "top.svh"
`include "uvm_macros.svh"

import uvm_pkg::*;
class pcie_pwr_mgmt_driver extends uvm_driver#(pcie_pwr_mgmt_seq_item);
  `uvm_component_utils(pcie_pwr_mgmt_driver)
  virtual pcie_if vif;
  pcie_pwr_mgmt_agent_config agt_cnfg;

  `define PMDRIV_IF vif.PWR_MGMT_DRIVER_MODPORT.pwr_mgmt_driver_cb

  function new(string name = "pcie_pwr_mgmt_driver", uvm_component parent);
    super.new(name, parent);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(pcie_pwr_mgmt_agent_config)::get(this, "", "agt_cnfg", agt_cnfg))
      `uvm_fatal(get_full_name(), "pwr_mgmt driver config not found")
  endfunction
  function void connect_phase(uvm_phase phase);
    vif = agt_cnfg.vif;
  endfunction

  extern task drive_reset();
  extern task run_phase(uvm_phase phase);
  extern task drive(pcie_pwr_mgmt_seq_item req);
endclass

task pcie_pwr_mgmt_driver::drive_reset();
  `PMDRIV_IF.enter_l0s_req <= 1'b0;
  `PMDRIV_IF.enter_l1_req  <= 1'b0;
  `PMDRIV_IF.exit_lowpower <= 1'b0;
endtask

task pcie_pwr_mgmt_driver::run_phase(uvm_phase phase);
  drive_reset();
  forever begin
    seq_item_port.get_next_item(req);
    drive(req);
    seq_item_port.item_done();
  end
endtask

// drives ASPM L0s/L1 entry/exit requests into the LTSSM (pcie_ltssm.v L0S/L1
// states) -- only valid once link_up, per PMDRIV_IF.link_up gate
task pcie_pwr_mgmt_driver::drive(pcie_pwr_mgmt_seq_item req);
  do @(`PMDRIV_IF); while (!`PMDRIV_IF.link_up);
  `PMDRIV_IF.enter_l0s_req <= req.enter_l0s_req;
  `PMDRIV_IF.enter_l1_req  <= req.enter_l1_req;
  `PMDRIV_IF.exit_lowpower <= req.exit_lowpower;
  @(`PMDRIV_IF);
  `PMDRIV_IF.enter_l0s_req <= 1'b0;
  `PMDRIV_IF.enter_l1_req  <= 1'b0;
  `PMDRIV_IF.exit_lowpower <= 1'b0;
  `uvm_info("PM_DRV", $sformatf("drove %s", req.convert2string()), UVM_LOW)
endtask
