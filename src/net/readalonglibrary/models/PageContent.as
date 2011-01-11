package net.readalonglibrary.models
{
	import flash.display.Bitmap;

	public class PageContent
	{
		public var name:String;
		public var content:Bitmap;
		
		public function PageContent(name:String, content:Bitmap)
		{
			this.name = name;
			this.content = content;
		}
	}
}