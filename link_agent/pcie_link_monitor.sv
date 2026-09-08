`include "top.svh"
`include "uvm_macros.svh"

import uvm_pkg::*;
class pcie_link_monitor extends uvm_monitor;
  `uvm_component_utils(pcie_link_monitor)
  virtual pcie_if vif;
  pcie_link_agent_config agt_cnfg;
  uvm_analysis_port#(pcie_link_seq_item) mon_port;

  `define LMON_IF vif.LINK_MONITOR_MODPORT.link_monitor_cb

  function new(string name = "pcie_link_monitor", uvm_component parent);
    super.new(name, parent);
    mon_port = new("mon_port", this);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(pcie_link_agent_config)::get(this, "", "agt_cnfg", agt_cnfg))
      `uvm_fatal(get_full_name(), "link monitor config not found")
  endfunction
  function void connect_phase(uvm_phase phase);
    vif = agt_cnfg.vif;
  endfunction

  extern task run_phase(uvm_phase phase);
  extern task collect_data();
endclass

task pcie_link_monitor::run_phase(uvm_phase phase);
  forever collect_data();
endtask

task pcie_link_monitor::collect_data();
  pcie_link_seq_item item;
  @(`LMON_IF);
  if (`LMON_IF.dll_dllp_valid) begin
    item = pcie_link_seq_item::type_id::create("item");
    item.dllp_valid = 1'b1;
    item.dllp_type  = `LMON_IF.dll_dllp_type;
    item.dllp_seq   = `LMON_IF.dll_dllp_seq;
    mon_port.write(item);
  end
endtask
