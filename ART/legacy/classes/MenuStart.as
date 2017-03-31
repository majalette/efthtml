package 
{
	import MenuSelection;

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

	public class MenuStart extends Sprite
	{
		private var loaderFondMenu:Loader;
		private var requeteFondMenu:URLRequest;
		private var conteneurFondMenu:MovieClip;
		private var compteur:Timer;

		private var menuSelect:MenuSelection;

		public function MenuStart()
		{
			/************Chargement de l'animation des éclairs et du titre**************/
			loaderFondMenu = new Loader  ;
			loaderFondMenu.contentLoaderInfo.addEventListener(Event.COMPLETE,chargementComplet);
			requeteFondMenu = new URLRequest("swf/menustart.swf");
			loaderFondMenu.load(requeteFondMenu);
			menuSelect = new MenuSelection  ;
			/************Compteur de 3 secondes qui ajoute un écouteur pour la touche ENTER**************/
			compteur = new Timer(3000,1);
			compteur.addEventListener(TimerEvent.TIMER_COMPLETE, timerComplet);

		}
		/************Lorsque l'animation est completement chargée, la mettre en pause et attendre que la classe soit ajoutée à la scène**************/
		private function chargementComplet(evt:Event):void
		{
			conteneurFondMenu = new MovieClip();
			conteneurFondMenu = MovieClip(evt.currentTarget.content.getChildAt(0));
			conteneurFondMenu.stop();
			addChild(conteneurFondMenu);
			this.addEventListener(Event.ADDED_TO_STAGE,menuActif);


		}
		/*************Faire jouer l'animation et démarrer le timer puisque la classe a été ajoutée à la scène*************/
		private function menuActif(evt:Event):void
		{
			compteur.start();
			conteneurFondMenu.play();
			this.removeEventListener(Event.ADDED_TO_STAGE,menuActif);
		}

		/*************Lorsque le timer atteint 3 secondes, ajouter l'écouteur de la touche ENTER*************/
		private function timerComplet(evt:TimerEvent):void
		{
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN,toucheDown);
		}

		/************Lorsqu'on appuie sur ENTER déclencher le fondu et passer au menu de sélection**************/
		private function toucheDown(event:KeyboardEvent):void
		{
			var key:uint = event.keyCode;
			switch (key)
			{
				case Keyboard.ENTER :
					Main.fade.fadeOut();
					loaderFondMenu.unloadAndStop();
					this.stage.removeEventListener(KeyboardEvent.KEY_DOWN,toucheDown);
					this.stage.addEventListener(Event.ENTER_FRAME,changeEcran);
					break;
			}

		}
		private function changeEcran(evt:Event):void
		{
			if (Main.fade.alpha >= 1)
			{
				this.parent.addChild(menuSelect);
				Main.fade.fadeIn();
				this.stage.removeEventListener(Event.ENTER_FRAME,changeEcran);
				this.parent.removeChild(this);
			}

		}
	}
}