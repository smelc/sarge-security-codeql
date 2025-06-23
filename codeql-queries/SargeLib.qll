/**
 * This file has the qll extension because it is meant to be imported.
 * ql files on the other hand, are meant to contain a query and so
 * cannot be imported.
 *
 * See https://codeql.github.com/docs/ql-language-reference/modules/#kinds-of-modules
 */

import python
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.internal.DataFlowPublic

private API::CallNode get_run_call() {
  result = API::moduleImport("sarge").getMember("run").getACall()
}

class DangerousSargeRunArg extends DataFlow::Node {
  DangerousSargeRunArg() {
    this = get_run_call().getArgByName("input") or
    this = get_run_call().getArg(0)
  }
}

class AppSanitizer extends DataFlow::Node {
  AppSanitizer() {
    exists(Expr expr |
      expr = this.asExpr() and
      expr.(Call).getFunc().(Name).getId() = "my_sanitizer"
    )
  }
}
