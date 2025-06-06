/**
 * @name GetSargeRunSinks
 * @description Find all sarge.run sinks in the project
 * @kind problem
 * @tags correctness
 * @problem.severity recommendation
 * @sub-severity low
 * @precision very-high
 * @id py/get-sarge-run-sinks
 */

import python
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.ApiGraphs

private API::CallNode get_run_call() {
  result = API::moduleImport("sarge").getMember("run").getACall()
}

// Does indeed find calls to sarge.run that use the "input" named argument
private DataFlow::Node get_run_call_named_input() { result = get_run_call().getArgByName("input") }

// Corresponding testing query, for reference:
// from DataFlow::Node src
// where src = get_run_call_named_input()
// select src, "Potential sarge.run sink"
// Doesn't find calls to sarge.run that use the "input" named argument;
// because the return type is too specific, surprising!
private API::CallNode get_run_call_named_input_wrong() {
  result = get_run_call().getArgByName("input")
}

// Corresponding testing query, for reference:
// from API::CallNode src
// where src = get_run_call_named_input_wrong()
// select src, "Potential sarge.run sink"
// class C extends DataFlow::Node {}
// class D extends C {}
// private C find_c() { none() }
// private D find_d() { none() }
// from C src, D src2
// where src = find_c() and src2 = src
// select src2
from API::CallNode src, DataFlow::Node fooArg
where
  src = get_run_call() and
  (
    fooArg = src.getArgByName("input") or
    fooArg = src.getArg(0)
  )
select fooArg, "Argument to 'foo' in some_func"
