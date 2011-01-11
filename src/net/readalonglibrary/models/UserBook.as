package net.readalonglibrary.models
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.media.Sound;
	import flash.net.URLRequest;
	
	import mx.collections.ArrayCollection;
	import mx.collections.Sort;
	import mx.collections.SortField;
	import mx.controls.Image;

	public class UserBook
	{

		public var name:String;
		public var thumbnailContent:Bitmap;
		public var firstPageContent:Bitmap;
		public var pageWidth:Number;
		public var pageHeight:Number;
		
		protected var _thumbnailIsFirstPage:Boolean = false;
		public var pages:ArrayCollection = new ArrayCollection();
		public var audio:Sound;
		public var isFullyLoaded:Boolean = false;
		
		protected var _directoryPath:String;
		protected var _directory:File;
		protected var _userLibrary:UserLibrary;
		protected var _imagePaths:ArrayCollection = new ArrayCollection();
		protected var _audioPath:String;
		protected var _audioLoaded:Boolean = false;
		
		public function UserBook(directoryPath:String, userLibrary:UserLibrary)
		{
			this._directoryPath = directoryPath;
			this._directory = new File(this._directoryPath);
			this._userLibrary = userLibrary;
			
			this.name = this._directory.name;
			
			this._loadThumbnail();
		}
		
		protected function _loadThumbnail():void
		{
			var loader:Loader;
			var thumbnailFile:File;
			var firstPageFile:File;
			thumbnailFile = new File(this._directoryPath + "/thumbnail.png");
			firstPageFile = new File(this._directoryPath + "/page_001.png");
			if(!thumbnailFile.exists)
			{
				thumbnailFile = firstPageFile;
				this._thumbnailIsFirstPage = true;
			}
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this._onThumbnailLoadComplete);
			loader.load(new URLRequest(thumbnailFile.url));
			
			if(!this._thumbnailIsFirstPage)
			{
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this._onFirstPageLoadComplete);
				loader.load(new URLRequest(firstPageFile.url));	
			}
			
		}
		
		protected function _onThumbnailLoadComplete(event:Event):void
		{
			this.thumbnailContent = (event.target as LoaderInfo).content as Bitmap;
			if(this._thumbnailIsFirstPage)
			{
				this.firstPageContent = this.thumbnailContent;
			}
			this._userLibrary.onThumbnailLoaded(event);
		}
		
		protected function _onFirstPageLoadComplete(event:Event):void
		{
			this.firstPageContent = (event.target as LoaderInfo).content as Bitmap;
			this.pageWidth = this.firstPageContent.width;
			this.pageHeight = this.firstPageContent.height;
		}
		
		public function loadAll():void
		{
			
			if(this.isFullyLoaded) 
			{
				this._userLibrary.onBookLoaded(this);
				return;
			}
			
			var i:int;
			var loader:Loader;
			var directoryListing:Array = this._directory.getDirectoryListing();
			var imagePaths:ArrayCollection = new ArrayCollection();
			
			for(i = 0; i < directoryListing.length; i++)
			{
				var file:File = directoryListing[i] as File;
				if(file.name.indexOf("page_") >= 0)
				{
					this._imagePaths.addItem(file.url);
				}
				else if(file.name == "audio.mp3")
				{
					this._audioPath = file.url;
				}
			}
			
			for(i = 0; i < this._imagePaths.length; i++)
			{
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this._onPageImageLoadComplete);
				loader.load(new URLRequest(this._imagePaths.getItemAt(i) as String));
			}
			
			if(this._audioPath != null)
			{
				this.audio = new Sound();
				this.audio.addEventListener(Event.COMPLETE, this._onAudioLoadComplete);
				this.audio.load(new URLRequest(this._audioPath));
			}
			
		}
		
		protected function _onPageImageLoadComplete(event:Event):void
		{
			var loaderInfo:LoaderInfo = (event.target as LoaderInfo);
			var fileName:String = loaderInfo.url.substring(loaderInfo.url.lastIndexOf(File.separator) + 1);
			this.pages.addItem(new PageContent(fileName, loaderInfo.content as Bitmap));
			if(pages.length == this._imagePaths.length)
			{
				this._sortPages();
				// we're done loading the pages, do we need to wait for audio?
				if(this._audioPath == null)
				{
					// we're done!  no audio
					this._userLibrary.onBookLoaded(this);
					this.isFullyLoaded = true;
				}
				else
				{
					// ok, so we have audio, is done loading yet?
					if(this._audioLoaded)
					{
						// we're done!
						this._userLibrary.onBookLoaded(this);
						this.isFullyLoaded = true;
					}
				}
			}
		}
		
		protected function _onAudioLoadComplete(event:Event):void
		{
			this._audioLoaded = true;
			// this might have been the last thing to load, let's see if all the pages loaded already
			if(this.pages.length == this._imagePaths.length)
			{
				// yep, we're done!
				this._userLibrary.onBookLoaded(this);
				this.isFullyLoaded = true;
			}
		}
		
		protected function _sortPages():void
		{
			var sortField:SortField = new SortField();
			sortField.name = "name";
			
			var sort:Sort = new Sort();
			sort.fields = [sortField];
			
			this.pages.sort = sort;
			this.pages.refresh();

		}
		
	}
}