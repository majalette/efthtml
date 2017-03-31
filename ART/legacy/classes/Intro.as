package 
{
	import MenuStart;

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

	public class Intro extends Sprite
	{

		private var loaderFondIntro:Loader;
		private var requeteFondMenu:URLRequest;
		private var conteneurFondMenu:MovieClip;
		private var menuStart:MenuStart;

		public function Intro()
		{
			/*************Chargement du swf d'introduction (explosion atomique)*************/
			loaderFondIntro = new Loader();
			loaderFondIntro.contentLoaderInfo.addEventListener(Event.COMPLETE, chargementComplet);
			requeteFondMenu = new URLRequest("swf/logo.swf");
			loaderFondIntro.load(requeteFondMenu);
			menuStart=new MenuStart();

		}
		/************Ajout de l'animation d'intro sur la scène et écouteur pour le fondu lorsqu'elle termine de jouer**************/
		private function chargementComplet(evt:Event):void
		{
			conteneurFondMenu = new MovieClip();
			conteneurFondMenu=MovieClip(evt.currentTarget.content);
			addChild(conteneurFondMenu);
			conteneurFondMenu.addEventListener(Event.ENTER_FRAME, finClip);

		}

		/************Exécution du fondu lorsque l'intro se termine**************/
		private function finClip(evt:Event):void{
			if(evt.currentTarget.clipBombe.currentFrame>=78){
						Main.fade.fadeOut();
						this.stage.addEventListener(Event.ENTER_FRAME, changeEcranIntro);
						conteneurFondMenu.removeEventListener(Event.ENTER_FRAME, finClip);
				}
		}

		
		/************Lorsque l'écran est complètement noir, ajout du menu START et retrait de l'intro de la scène, puis fondu entrant**************/
		private function changeEcranIntro(evt:Event):void{
			if (Main.fade.alpha>=1){
				loaderFondIntro.unloadAndStop();
				this.parent.addChild(menuStart);
				Main.fade.fadeIn();
				this.stage.removeEventListener(Event.ENTER_FRAME, changeEcranIntro);
				this.parent.removeChild(this);
				}
			
		}
	}
}