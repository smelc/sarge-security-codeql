/**
 * This file has the qll extension because it is meant to be imported.
 * ql files on the other hand, are meant to contain a query and so
 * cannot be imported.
 *
 * See https://codeql.github.com/docs/ql-language-reference/modules/#kinds-of-modules
 */

import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.DataFlow

class InputCall extends RemoteFlowSource::Range {
  InputCall() { this = API::builtin("input").getACall() }

  override string getSourceType() { result = "input built-in function" }
}

private API::CallNode get_run_call() {
  result = API::moduleImport("sarge").getMember("run").getACall()
}

class DangerousSargeRunArg extends DataFlow::Node {
  DangerousSargeRunArg() {
    this = get_run_call().getArgByName("input") or
    this = get_run_call().getArg(0)
  }
}
