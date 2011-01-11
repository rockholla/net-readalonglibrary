package net.readalonglibrary.events
{
	import flash.events.Event;
	
	public class ReadAlongLibraryEvent extends Event
	{
		
		public static const BOOK_SELECTED:String = "BookSelected";
		public static const PUT_BOOK_BACK:String = "putBookBack";
		public static const PLAY_AUDIO:String = "playAudio";
		public static const PAUSE_AUDIO:String = "pauseAudio";
		public static const STOP_AUDIO:String = "stopAudio";
		public static const SHOW_HELP:String = "showHelp";
		public static const SHOW_LOVE:String = "showLove";
		
		public function ReadAlongLibraryEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			
		}
	}
}