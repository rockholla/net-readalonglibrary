package net.readalonglibrary
{
	import net.readalonglibrary.controllers.ReadBookCommand;
	import net.readalonglibrary.controllers.StartupCommand;
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;
	import org.puremvc.as3.patterns.observer.Notification;
	
	public class ApplicationFacade extends Facade implements IFacade
	{
		
		public static const NAME:String	= "ApplicationFacade";
		public static const STARTUP:String = NAME + "_StartUp";
		public static const READ_BOOK:String = NAME + "ReadBook";

		protected var _application:Main;
		
		public static function getInstance():ApplicationFacade
		{
			return (instance ? instance : new ApplicationFacade()) as ApplicationFacade;
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			
			this.registerCommand(STARTUP, StartupCommand);
			this.registerCommand(READ_BOOK, ReadBookCommand);
		}
		
		public function get application():Main
		{
			return this._application;
		}
		
		public function startup(stage:Object):void
		{
			this._application = stage as Main;
			this.sendNotification(STARTUP, stage);
		}
		
		override public function sendNotification(notificationName:String, body:Object = null, type:String = null):void
		{
			trace('Sent ' + notificationName);
			this.notifyObservers(new Notification(notificationName, body, type));
		}
	}
}