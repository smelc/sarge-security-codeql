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
import SargeLib

from DangerousSargeRunArg arg
select arg, "Vulnerable argument to sarge.run()"
