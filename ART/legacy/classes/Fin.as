package 
{

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.net.URLRequest;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class Fin extends Sprite
	{

		private var loaderFondIntro:Loader;
		private var requeteFondMenu:URLRequest;
		private var conteneurFondMenu:MovieClip;
		private var nomPerso:String;
		private var monTimer:Timer;
		private var menuStart:MenuStart;
		private var delai

		public function Fin(_nomPerso:String)
		{
			/*************Chargement du swf de la fin*************/
			loaderFondIntro = new Loader();
			loaderFondIntro.contentLoaderInfo.addEventListener(Event.COMPLETE, chargementComplet);
			requeteFondMenu = new URLRequest("swf/fin.swf");
			this.addEventListener(Event.ADDED_TO_STAGE, finActif);
			nomPerso=_nomPerso;
			monTimer=new Timer(10000, 3);
		

		}
		
		private function finActif(evt:Event):void{
		loaderFondIntro.load(requeteFondMenu);
		}
		
		/************Ajout de l'animation d'intro sur la scène et écouteur pour le fondu pour changer d'image**************/
		private function chargementComplet(evt:Event):void
		{
			conteneurFondMenu = new MovieClip();
			conteneurFondMenu=MovieClip(evt.target.content.getChildAt(0));
			addChild(conteneurFondMenu);
			monTimer.addEventListener(TimerEvent.TIMER, passerImage);
			monTimer.start();

		}


		private function passerImage(evt:TimerEvent):void{
			Main.fade.fadeOut();
			switch(evt.currentTarget.currentCount){
				case 1:
				this.stage.addEventListener(Event.ENTER_FRAME, changeEcran1);
				break;
				case 2:
				this.stage.addEventListener(Event.ENTER_FRAME, changeEcran2);
				break;
				}
						
		}

		
		/************Lorsque l'écran est complètement noir, pon change d'image**************/
		private function changeEcran1(evt:Event):void{
			if (Main.fade.alpha>=1){
				conteneurFondMenu.gotoAndStop(nomPerso);
				Main.fade.fadeIn();
				this.stage.removeEventListener(Event.ENTER_FRAME, changeEcran1);
				}
			
		}
		private function changeEcran2(evt:Event):void{
			if (Main.fade.alpha>=1){
				conteneurFondMenu.gotoAndStop("cristaux");
				Main.fade.fadeIn();
				this.stage.removeEventListener(Event.ENTER_FRAME, changeEcran2);
				}
			
		}
	}
}