package  {
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.net.URLRequest;
	
	public class FadeToBlack extends Sprite {
		
		private var MenuPrincipal:MenuStart;
		private var loaderFade:Loader;
		private var urlFade:URLRequest;
		private var isTransparent:Boolean=true;
		private var fadeSpeed:Number=0.07;
		
		public function FadeToBlack() {
			
			loaderFade=new Loader();
			loaderFade.contentLoaderInfo.addEventListener(Event.COMPLETE, chargeFade);
			urlFade=new URLRequest("images/fade.jpg");
			loaderFade.load(urlFade);
		}
		
		private function chargeFade(evt:Event):void
		{
			this.addChild(evt.currentTarget.content);
			this.alpha=0;
		}
		
		public function fadeOut(){
			this.parent.setChildIndex(Main.fade, this.parent.numChildren-1);
			this.addEventListener(Event.ENTER_FRAME, changeOpacite);
			}
			
		public function fadeIn(){
			this.parent.setChildIndex(Main.fade, this.parent.numChildren-1);
			this.addEventListener(Event.ENTER_FRAME, changeOpacite);
			}
			
		private function changeOpacite(evt:Event):void{
			switch(isTransparent){
				case true:
					evt.currentTarget.alpha+=fadeSpeed;
					if(evt.currentTarget.alpha>=1){
						this.removeEventListener(Event.ENTER_FRAME, changeOpacite);
						isTransparent=false;
					}
				break;
				
				case false:
					evt.currentTarget.alpha-=fadeSpeed;
					if(evt.currentTarget.alpha<=0){
						this.removeEventListener(Event.ENTER_FRAME, changeOpacite);
						isTransparent=true;
						this.parent.setChildIndex(Main.fade, 0);
					}
				break;
			}

		}

	}
	
}
