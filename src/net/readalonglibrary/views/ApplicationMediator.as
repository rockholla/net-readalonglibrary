package net.readalonglibrary.views
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.setTimeout;
	
	import mx.binding.utils.ChangeWatcher;
	import mx.core.FlexGlobals;
	import mx.events.ResizeEvent;
	import mx.managers.PopUpManager;
	
	import net.readalonglibrary.ApplicationFacade;
	import net.readalonglibrary.events.ReadAlongLibraryEvent;
	import net.readalonglibrary.models.UserLibrary;
	import net.readalonglibrary.models.UserLibraryProxy;
	import net.readalonglibrary.views.popups.PopUpInfo;
	import net.readalonglibrary.views.popups.PopUpError;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ApplicationMediator extends Mediator implements IMediator
	{
		public static const NAME:String = "ApplicationMediator";
		
		public static const PROCESS_STARTED:String = NAME + "_ProcessStarted";
		public static const PROCESS_COMPLETE:String = NAME + "_ProcessComplete";
		public static const LIBRARY_LOADED:String = NAME + "_LibraryLoaded";
		public static const BOOK_SELECTED:String = NAME + "_BookSelected";
		public static const BOOK_LOADED:String = NAME + "_BookLoaded";
		public static const PUT_BOOK_BACK:String = NAME + "_PutBookBack";
		
		protected var _proxy:UserLibraryProxy;
		protected var _widthWatcher:ChangeWatcher;
		protected var _heightWatcher:ChangeWatcher;
		protected var _resizing:Boolean = false;
		protected var _soundChannel:SoundChannel;
		protected var _pausePosition:Number = -1;
		
		public function ApplicationMediator(viewComponent:Object = null)
		{
			super(NAME, viewComponent);
			this._onApplicationResize();
		}
		
		public function get application():Main
		{
			return this.viewComponent as Main;
		}
		
		override public function onRegister():void
		{
			this._proxy = this.facade.retrieveProxy(UserLibraryProxy.NAME) as UserLibraryProxy;
			
			this.application.libraryDisplay.addEventListener(ReadAlongLibraryEvent.BOOK_SELECTED, this._onBookSelected);
			this.application.readerDisplay.addEventListener(ReadAlongLibraryEvent.PUT_BOOK_BACK, this._onPutBookBack);
			this.application.readerDisplay.addEventListener(ReadAlongLibraryEvent.PLAY_AUDIO, this._onPlayAudio);
			this.application.readerDisplay.addEventListener(ReadAlongLibraryEvent.PAUSE_AUDIO, this._onPauseAudio);
			this.application.readerDisplay.addEventListener(ReadAlongLibraryEvent.STOP_AUDIO, this._onStopAudio);
			
			this.application.addEventListener(ReadAlongLibraryEvent.SHOW_HELP, this._onShowHelp);
			
			FlexGlobals.topLevelApplication.systemManager.stage.addEventListener(ResizeEvent.RESIZE, this._onApplicationResize);
			FlexGlobals.topLevelApplication.systemManager.stage.addEventListener(Event.FULLSCREEN, this._onApplicationResize);
			
			if(this._proxy.userLibrary.userBooks.length == 0)
			{
				this.sendNotification(PROCESS_COMPLETE);
				var alert:PopUpError = PopUpManager.createPopUp(this.application, PopUpError, true) as PopUpError;
				alert.title = "Oops, there's an empty library";
				alert.message = "There aren't any books in your library!  Add books to " + UserLibrary.LIBRARY_PATH + " to get started.";
			}
			
		}
		
		protected function _onApplicationResize(event:Event = null):void
		{
			this.application.libraryDisplay.width = this.application.readerDisplay.width = this.application.width;
			this.application.libraryDisplay.height = this.application.readerDisplay.height = this.application.height;
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				PROCESS_STARTED,
				PROCESS_COMPLETE,
				LIBRARY_LOADED,
				BOOK_SELECTED,
				BOOK_LOADED,
				PUT_BOOK_BACK
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			
			var name:String = notification.getName();
			var body:Object = notification.getBody();
			
			switch(name)
			{
				case(PROCESS_STARTED):
				{
					this.application.loadingMask.isLoading = true;
					break;
				}
				case(PROCESS_COMPLETE):
				{
					this.application.loadingMask.isLoading = false;
					break;
				}
				case(LIBRARY_LOADED):
				{
					this.application.libraryDisplay.userLibrary = this._proxy.userLibrary;
					this.sendNotification(PROCESS_COMPLETE);
					break;
				}
				case(BOOK_SELECTED):
				{
					this.sendNotification(PROCESS_STARTED);
					this.sendNotification(ApplicationFacade.READ_BOOK, (body as Thumbnail).userBook.name);
					break;
				}
				case(BOOK_LOADED):
				{
					this._createFlippableBook();
					break;
				}
				case(PUT_BOOK_BACK):
				{
					this.application.readerDisplay.removeBook();
					this.application.readerDisplay.visible = false;
					this.application.libraryDisplay.selectedThumbnail.visible = true;
					this.application.libraryDisplay.selectedThumbnail.putBack();
					this._proxy.userLibrary.loadedBook = null;
					this._onStopAudio();
					break;
				}
			}
			
		}
		
		protected function _onBookSelected(event:ReadAlongLibraryEvent):void
		{
			this.sendNotification(BOOK_SELECTED, event.target);
		}
		
		protected function _createFlippableBook():void
		{
			
			this.application.readerDisplay.thumbnail = this.application.libraryDisplay.selectedThumbnail;
			this.application.readerDisplay.visible = true;
			this.application.readerDisplay.addBook(this._proxy.userLibrary.loadedBook);
			
			flash.utils.setTimeout(this._enableRead, 1000);
			
		}
		
		protected function _enableRead():void
		{
			this.application.libraryDisplay.selectedThumbnail.visible = false;
			this.sendNotification(PROCESS_COMPLETE);
		}
		
		protected function _onBookOpened(event:Event):void
		{
			this.application.libraryDisplay.selectedThumbnail.visible = false;
			this._onPlayAudio(event);
		}
		
		protected function _onPutBookBack(event:ReadAlongLibraryEvent):void
		{
			this.sendNotification(PUT_BOOK_BACK, event.target);
		}
		
		protected function _onPlayAudio(event:Event):void
		{
			var audio:Sound = this.application.readerDisplay.thumbnail.userBook.audio;
			if(audio != null && this._soundChannel == null)
			{
				if(this._pausePosition > 0)
				{
					this._soundChannel = audio.play(this._pausePosition);
				}
				else
				{
					this._soundChannel = audio.play();	
				}	
			}
			this._pausePosition = -1;
		}
		
		protected function _onPauseAudio(event:Event):void
		{
			if(this._soundChannel != null)
			{
				this._pausePosition = this._soundChannel.position;
				this._soundChannel.stop();
				this._soundChannel = null;	
			}
		}
		
		protected function _onStopAudio(event:Event = null):void
		{
			if(this._soundChannel != null)
			{
				this._soundChannel.stop();
				this._soundChannel = null;	
			}
			this._pausePosition = -1;
		}
		
		protected function _onShowHelp(event:Event):void
		{
			var infoAlert:PopUpInfo = PopUpManager.createPopUp(this.application, PopUpInfo, true) as PopUpInfo;
			infoAlert.title = "Oh, Hello";
			infoAlert.message = "If you're reading this, you've discovered a great secret:  you've learned how to ask for help!  Please visit https://github.com/rockholla/net-readalonglibrary/blob/master/README for more info.";
		}

	}
}