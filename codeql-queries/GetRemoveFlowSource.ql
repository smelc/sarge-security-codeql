 /**
 * @name GetRemoteFlowSource
 * @description Find all flow sources in the project
 * @kind problem
 * @tags correctness
 * @problem.severity recommendation
 * @sub-severity low
 * @precision very-high
 * @id py/get-remote-flow-source
 */
import python
import semmle.python.dataflow.new.RemoteFlowSources

from RemoteFlowSource::Range src
select src, "Potential flow source"