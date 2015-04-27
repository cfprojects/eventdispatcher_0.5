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


<cfcomponent output="false" hint="An event dispatcher (close to ActionScript 3's) that can add or removing event listeners, checking whether specific types of event listeners are registered, and dispatching events.">

<cffunction name="init" output="false" hint="Constructor.">
	<cfset variables.System = createObject("java", "java.lang.System") />
	<cfset variables.listenerFunctions = structNew() />
	<cfset variables.listeners = structNew() />
	<cfreturn this />
</cffunction>

<cffunction name="addEventListener" returntype="void" output="false" hint="Registers an event listener object with this EventDispatcher object so that the listener receives notification of an event.">
	<cfargument name="eventType" type="string" hint="The event's name." />
	<cfargument name="listener" type="any" hint="The CFC instance that needs to listen for an event." />
	<cfargument name="listenerFunction" type="any" hint="The _function reference_ to the function to call when the event is dispatched.  If you have a CFC instance named ""widget"" and you want its ""ordered"" function to be called as a listener, you'd pass widget.ordered to this." />

	<cfset var listenerId = System.identityHashCode(arguments.listener) />
	<cfset var md = getMetadata(listenerFunction) />
	
	<!--- Listeners for event name --->
	<cfif not structKeyExists(variables.listenerFunctions, arguments.eventType)>
		<cfset variables.listenerFunctions[arguments.eventType] = structNew() />
	</cfif>
	
	<!--- Listeners by observer instances --->
	<cfif not structKeyExists(variables.listenerFunctions[arguments.eventType], listenerId)>
		<cfset variables.listenerFunctions[arguments.eventType][listenerId] = structNew() />
	</cfif>
	<cfif not structKeyExists(variables.listeners, listenerId)>
		<cfset variables.listeners[listenerId] = arguments.listener />
	</cfif>
			
	<!--- Listener by function --->
	<cfif not structKeyExists(variables.listenerFunctions[arguments.eventType][listenerId], md.name)>
		<cfset variables.listenerFunctions[arguments.eventType][listenerId][md.name] = 1 />
	</cfif>
</cffunction>

<cffunction name="hasEventListener" returntype="boolean" output="false" hint="States if any listeners are registered for a given event name.">
	<cfargument name="eventType" type="string" hint="The event's name." />
	<cfreturn structKeyExists(variables.listenerFunctions, arguments.eventType) />
</cffunction>

<cffunction name="removeEventListener" returntype="void" output="false" hint="Removes a listener.">
	<cfargument name="eventType" type="string" hint="The event's name." />
	<cfargument name="listener" type="any" hint="The CFC instance whose listener needs to be removed." />
	<cfargument name="listenerFunction" type="any" hint="The function reference to remove." />
	
	<cfset var listenerId = System.identityHashCode(arguments.listener) />
	<cfset var md = getMetadata(listenerFunction) />

	<cfif structKeyExists(variables.listenerFunctions, arguments.eventType)
				and structKeyExists(variables.listenerFunctions[arguments.eventType], listenerId)
				and structKeyExists(variables.listenerFunctions[arguments.eventType][listenerId], md.name)
	>
		<cfset structDelete(variables.listenerFunctions[arguments.eventType][listenerId], md.name)>
		<cfif not structCount(variables.listenerFunctions[arguments.eventType][listenerId])>
			<cfset structDelete(variables.listenerFunctions[arguments.eventType], listenerId)>
			<cfset structDelete(variables.listeners, listenerId) />
		</cfif>
		<cfif not structCount(variables.listenerFunctions[arguments.eventType])>
			<cfset structDelete(variables.listenerFunctions, arguments.eventType)>
		</cfif>
	</cfif>
</cffunction>
						 
<cffunction name="dispatchEvent" returntype="void" output="false" hint="Dispatches an event, firing any registered listener functions.">
	<cfargument name="event" type="com.firemoss.eventdispatcher.Event" hint="Event (or subclass) to dispatch." />

	<cfset var listener = "" />
	<cfset var listeners = 0 />	
	<cfset var listenerId = 0 />
	<cfset var functionName = 0 />
	
	<cfif hasEventListener(event.getType())>
		<cfset listeners = variables.listenerFunctions[event.getType()] />
		<cfloop collection="#listeners#" item="listenerId">
			<cfloop collection="#listeners[listenerId]#" item="functionName">
				<cfset listener = variables.listeners[listenerId] />
				<!--- Can't require single argument to be named "event", hence evaluate.  It's not that slow anymore. --->
				<cfset evaluate("listener.#functionName#(event)") />
			</cfloop>
		</cfloop>
	</cfif>
</cffunction>

</cfcomponent>