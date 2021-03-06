// =================================================================================================
//
//	CoreApp Framework
//	Copyright 2012 Unwrong Ltd. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package core.app.managers.fileSystemProviders.local
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.OutputProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import core.app.core.managers.fileSystemProviders.IFileSystemProvider;
	import core.app.core.managers.fileSystemProviders.operations.IWriteFileOperation;
	import core.app.entities.URI;
	import core.app.events.FileSystemErrorCodes;
	import core.app.events.OperationProgressEvent;
	import core.app.util.AsynchronousUtil;

	internal class WriteFileOperation extends LocalFileSystemProviderOperation implements IWriteFileOperation
	{
		private var fileStream	:FileStream;
		private var _bytes		:ByteArray;
		
		public function WriteFileOperation(rootDirectory:File, uri:URI, bytes:ByteArray, fileSystemProvider:IFileSystemProvider )
		{
			super(rootDirectory, uri, fileSystemProvider);
			_bytes = bytes;
		}
		
		private function dispose():void
		{
			if ( fileStream )
			{
				fileStream.close();
				fileStream.removeEventListener( OutputProgressEvent.OUTPUT_PROGRESS, writeProgressHandler );
				fileStream.removeEventListener( IOErrorEvent.IO_ERROR, writeErrorHandler );
				fileStream = null;
			}
		}
		
		override public function execute():void
		{
			//var file:File = new File( uriToFilePath(_uri) );
			var file:File = new File( FileSystemUtil.uriToFilePath( _uri, _rootDirectory ) );
			
			fileStream = new FileStream();
			
			//if ( _bytes.length == 0 )
			//{
			//	AsynchronousUtil.dispatchLater( this, new ErrorEvent( ErrorEvent.ERROR, false, false, "", FileSystemErrorCodes.WRITE_FILE_ERROR ) );
			//	return;
			//}
			//else
			//{
				fileStream.openAsync( file, FileMode.WRITE );
				
				if ( _bytes.length == 0 )
				{
					AsynchronousUtil.dispatchLater( this, new Event( Event.COMPLETE ) );
					dispose();
				}
				else
				{
					fileStream.addEventListener( OutputProgressEvent.OUTPUT_PROGRESS, writeProgressHandler );
					fileStream.addEventListener( IOErrorEvent.IO_ERROR, writeErrorHandler );
					fileStream.writeBytes( _bytes, 0, _bytes.length );
				}
				
			//}
		}
		
		private function writeErrorHandler( event:IOErrorEvent ):void
		{
			dispatchEvent( new ErrorEvent( ErrorEvent.ERROR, false, false, "", FileSystemErrorCodes.WRITE_FILE_ERROR ) );
			dispose();
		}
		
		private function writeProgressHandler( event:OutputProgressEvent ):void
		{
			dispatchEvent( new OperationProgressEvent( OperationProgressEvent.PROGRESS, event.bytesTotal / event.bytesPending ) );
			
			if ( event.bytesPending == 0 )
			{
				dispatchEvent( new Event( Event.COMPLETE ) );
				dispose();
			}
		}
		
		override public function get label():String
		{
			return "Write file : " + _uri.path;
		}
		
		public function get bytes():ByteArray
		{
			return _bytes;
		}
	}
}