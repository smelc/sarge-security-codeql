/**
 * @name GetSanitizer
 * @description Find calls to our custom sanitizer in the project
 * @kind problem
 * @tags correctness
 * @problem.severity recommendation
 * @sub-severity low
 * @precision very-high
 * @id py/get-sanitizer
 */

import python
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.internal.DataFlowPublic

from Node node
where node.asExpr().(Call).getFunc().(Name).getId() = "my_sanitizer"
select node.asExpr().(Call).getFunc().(Name).getId(), "Sanitizer found?"
