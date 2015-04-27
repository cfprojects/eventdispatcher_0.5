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


<cfcomponent output="false" hint="Represents an event that can be dispatched through EventDispatcher.">

<cffunction name="init" output="false">
	<cfargument name="eventType" type="string" hint="The type of event." />
	<cfset variables._type = arguments.eventType />
	<cfset variables._data = structNew() />
	<cfreturn this />
</cffunction>

<cffunction name="getType" returntype="string" output="false" hint="Returns the type of this event.">
	<cfreturn variables._type />
</cffunction>

<cffunction name="getData" returntype="struct" output="false" hint="Returns a struture of ""data"" associated with this event.">
	<cfreturn variables._data />
</cffunction>
<cffunction name="setData" returntype="void" output="false" hint="Sets a struture of ""data"" associated with this event.">
	<cfargument name="data" type="struct" />
	<cfset variables._data = data />
</cffunction>

</cfcomponent>