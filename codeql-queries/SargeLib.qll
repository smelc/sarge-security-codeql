/**
 * This file has the qll extension because it is meant to be imported.
 * ql files on the other hand, are meant to contain a query and so
 * cannot be imported.
 *
 * See https://codeql.github.com/docs/ql-language-reference/modules/#kinds-of-modules
 */

import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.ApiGraphs

class InputCall extends RemoteFlowSource::Range {
  InputCall() { this = API::builtin("input").getACall() }

  override string getSourceType() { result = "input built-in function" }
}
