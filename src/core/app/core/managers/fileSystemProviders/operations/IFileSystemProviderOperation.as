// =================================================================================================
//
//	CoreApp Framework
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package core.app.core.managers.fileSystemProviders.operations
{
	import core.app.core.managers.fileSystemProviders.IFileSystemProvider;
	import core.app.core.operations.IAsynchronousOperation;
	import core.app.entities.URI;

	[Event(type="coreApp.apps.events.FileSystemErrorEvent", name="error")]
	[Event(type="flash.events.Event", name="complete")]
	[Event(type="core.app.events.OperationProgressEvent", name="progress")]
	
	public interface IFileSystemProviderOperation extends IAsynchronousOperation
	{
		function get uri():URI;
		function get fileSystemProvider():IFileSystemProvider;
	}
}