/**
 * @name Code injection
 * @description Interpreting unsanitized user input as code allows a malicious user to perform arbitrary
 *              code execution.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.3
 * @sub-severity high
 * @precision high
 * @id py/code-injection
 * @tags security
 *       external/cwe/cwe-094
 *       external/cwe/cwe-095
 *       external/cwe/cwe-116
 */


import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.ApiGraphs
import SargeFlow::PathGraph // Try uncommenting me to see a warning appear

import SargeLib // Required for the taint tracking query below to consider "input"
                // as an additional tainting source.
                // See https://codeql.github.com/docs/ql-language-reference/evaluation-of-ql-programs/#process

private module SargeConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource
  }

  predicate isSink(DataFlow::Node sink) {
    sink = API::moduleImport("sarge").getMember("run").getACall().getArg(0)
  }
}

module SargeFlow = TaintTracking::Global<SargeConfig>;

from SargeFlow::PathNode source, SargeFlow::PathNode sink
where SargeFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Tainted data passed to sarge"