<!---
LICENSE INFORMATION:

Copyright 2007, Firemoss, LLC
 
Licensed under the Apache License, Version 2.0 (the "License"); you may not 
use this file except in compliance with the License. 

You may obtain a copy of the License at 

	http://www.apache.org/licenses/LICENSE-2.0 
	
Unless required by applicable law or agreed to in writing, software distributed
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
CONDITIONS OF ANY KIND, either express or implied. See the License for the 
specific language governing permissions and limitations under the License.

VERSION INFORMATION:

This file is part of BeanUtils Alpha (0.5).

The version number in parenthesis is in the format versionNumber.subversion.revisionNumber.
--->


<cfcomponent extends="org.cfcunit.framework.TestCase">

<cffunction name="testAddHasRemoveEventListener" access="public" returntype="void" output="false">
	<cfset var disp = createObject("component", "com.firemoss.eventdispatcher.EventDispatcher").init() />
	<cfset var obs = createObject("component", "com.firemoss.eventdispatcher.test.Observer") />
	<cfset var obs2 = createObject("component", "com.firemoss.eventdispatcher.test.Observer") />
	<cfset var EVENT_TYPE = "EVENT_TYPE" />
	
	<cfset disp.addEventListener(EVENT_TYPE, obs, obs.listenerFunction) />
	<cfset disp.addEventListener(EVENT_TYPE, obs2, obs2.listenerFunction) />
	
	<cfset assertTrue(disp.hasEventListener(EVENT_TYPE), "hasEventListener failed after add") />
	
	<cfset disp.removeEventListener(EVENT_TYPE, obs, obs.listenerFunction) />
	
	<cfset assertTrue(disp.hasEventListener(EVENT_TYPE), "hasEventListener failed after first remove") />

	<cfset disp.removeEventListener(EVENT_TYPE, obs2, obs2.listenerFunction) />
	
	<cfset assertFalse(disp.hasEventListener(EVENT_TYPE), "hasEventListener failed after second remove") />
</cffunction>

<cffunction name="testDispatchEvent" access="public" returntype="void" output="false">
	<cfset var disp = createObject("component", "com.firemoss.eventdispatcher.EventDispatcher").init() />
	<cfset var obs = createObject("component", "com.firemoss.eventdispatcher.test.Observer") />
	<cfset var obs2 = createObject("component", "com.firemoss.eventdispatcher.test.Observer") />
	<cfset var obs3 = createObject("component", "com.firemoss.eventdispatcher.test.Observer") />
	<cfset var EVENT_TYPE = "EVENT_TYPE" />
	<cfset var EVENT_TYPE_2 = "EVENT_TYPE_2" />
	<cfset var event = createObject("component", "com.firemoss.eventdispatcher.Event").init(EVENT_TYPE) />
	
	<cfset disp.addEventListener(EVENT_TYPE, obs, obs.listenerFunction) />
	<cfset disp.addEventListener(EVENT_TYPE, obs2, obs2.listenerFunction) />
	<cfset disp.addEventListener(EVENT_TYPE_2, obs3, obs3.listenerFunction) />
	
	<cfset disp.dispatchEvent(event) />
	
	<cfset assertTrue(obs.listenerInvoked, "First obs listener not invoked.") />
	<cfset assertTrue(obs2.listenerInvoked, "Second obs listener not invoked.") />
	<cfset assertFalse(obs3.listenerInvoked, "Third obs listener invoked (it shouldn't be!).") />
</cffunction>

</cfcomponent>