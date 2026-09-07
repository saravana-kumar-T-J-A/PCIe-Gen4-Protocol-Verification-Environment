`include "top.svh"
`include "uvm_macros.svh"

import uvm_pkg::*;
class pcie_pwr_mgmt_monitor extends uvm_monitor;
  `uvm_component_utils(pcie_pwr_mgmt_monitor)
  virtual pcie_if vif;
  pcie_pwr_mgmt_agent_config agt_cnfg;
  uvm_analysis_port#(pcie_pwr_mgmt_seq_item) mon_port;

  `define PMMON_IF vif.PWR_MGMT_MONITOR_MODPORT.pwr_mgmt_monitor_cb

  function new(string name = "pcie_pwr_mgmt_monitor", uvm_component parent);
    super.new(name, parent);
    mon_port = new("mon_port", this);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(pcie_pwr_mgmt_agent_config)::get(this, "", "agt_cnfg", agt_cnfg))
      `uvm_fatal(get_full_name(), "pwr_mgmt monitor config not found")
  endfunction
  function void connect_phase(uvm_phase phase);
    vif = agt_cnfg.vif;
  endfunction

  extern task run_phase(uvm_phase phase);
  extern task collect_data();
endclass

task pcie_pwr_mgmt_monitor::run_phase(uvm_phase phase);
  forever collect_data();
endtask

task pcie_pwr_mgmt_monitor::collect_data();
  pcie_pwr_mgmt_seq_item item;
  @(`PMMON_IF);
  if (`PMMON_IF.enter_l0s_req || `PMMON_IF.enter_l1_req || `PMMON_IF.exit_lowpower) begin
    item = pcie_pwr_mgmt_seq_item::type_id::create("item");
    item.enter_l0s_req = `PMMON_IF.enter_l0s_req;
    item.enter_l1_req  = `PMMON_IF.enter_l1_req;
    item.exit_lowpower = `PMMON_IF.exit_lowpower;
    mon_port.write(item);
  end
endtask
