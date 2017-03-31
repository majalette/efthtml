package 
{
	import Adversaire;
	import Combat;

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.net.URLRequest;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.media.Sound;

/************* Classe qui charge tout les médias nécessaires pour un combat selon le personnage choisi et son adversaire *************/
	public class ChargeurCombat extends Sprite
	{
		private var leCombat:Combat;
		
		private var loaderFond:Loader;
		private var requestFond:URLRequest;

		private var loaderNiveau:Loader;
		private var requestNiveau:URLRequest;
		
		private var musiqueNiveau:Sound;
		private var requestMusiqueNiveau:URLRequest;

		private var loaderPlayerVs:Loader;
		private var requestPlayerVs:URLRequest;

		private var loaderAdversaireVs:Loader;
		private var requestAdversaireVs:URLRequest;
		
		private var persoChoisi:String;
		private var nomAdversaire:String;
		private var nomNiveau:String;
		private var nomMusique:String;

		private var controleAuto:Adversaire;
		private var loaderAdv:Loader;
		private var adversaire:MovieClip;

		private var loaderPlayer1:Loader;
		private var requestPlayer1:URLRequest;
		private var loaderPlayer2:Loader;
		private var requestPlayer2:URLRequest;
		
		private var player1:MovieClip;
		private var player2:MovieClip;
		private var niveau:MovieClip;

		private var loaderChargement:Loader;
		private var requestChargement:URLRequest;
		private var conteneurLoading:MovieClip;

		private var loaderMusique:Loader;
		private var requestMusique:URLRequest;

		private var loaderFondCombat:Loader;
		private var requestFondCombat:URLRequest;
		
		private var etatChargement:int=0;

		public function ChargeurCombat(_persoChoisi:String)
		{

			persoChoisi=_persoChoisi;
			nomAdversaire = Main.parcoursAdversaire[Main.ennemi];
			nomNiveau = Main.niveau[nomAdversaire];
			nomMusique = "musique_"+nomNiveau+".mp3";
			
			loaderFond = new Loader();
			requestFond = new URLRequest("images/versus.jpg");
			loaderFond.load(requestFond);
			addChild(loaderFond);

			loaderPlayerVs = new Loader();
			requestPlayerVs = new URLRequest("images/" + persoChoisi + "_vs.png");
			loaderPlayerVs.load(requestPlayerVs);
			loaderPlayerVs.y = 150;
			addChild(loaderPlayerVs);

			loaderAdversaireVs = new Loader();
			requestPlayerVs = new URLRequest("images/" + nomAdversaire + "_vs.png");
			loaderAdversaireVs.load(requestPlayerVs);
			loaderAdversaireVs.y = 150;
			loaderAdversaireVs.x = 1000;
			loaderAdversaireVs.scaleX = -1;
			addChild(loaderAdversaireVs);

			conteneurLoading=new MovieClip();
			loaderChargement = new Loader();
			loaderChargement.contentLoaderInfo.addEventListener(Event.COMPLETE, finChargementLoading);
			requestChargement = new URLRequest("swf/loading.swf");
			loaderChargement.load(requestChargement);

			loaderPlayer1=new Loader();
			requestPlayer1 = new URLRequest("swf/" + persoChoisi + ".swf");
			
			loaderPlayer2=new Loader();
			requestPlayer2 = new URLRequest("swf/" + nomAdversaire + ".swf");
			
			loaderNiveau=new Loader();
			requestNiveau = new URLRequest("swf/stage.swf");
			
			musiqueNiveau=new Sound();
			requestMusiqueNiveau=new URLRequest("audio/"+nomMusique);
			musiqueNiveau.load(requestMusiqueNiveau);

			
			loaderMusique = new Loader();
			requestMusique = new URLRequest("swf/musique_versus.swf");

			this.addEventListener(Event.ADDED_TO_STAGE, menuActif);


		}

		private function finChargementLoading(evt:Event):void
		{

			conteneurLoading = MovieClip(evt.target.content);
			conteneurLoading.x = 315;
			conteneurLoading.y = 609;
			addChild(conteneurLoading);
		}

		private function menuActif(evt:Event):void
		{
			loaderMusique.load(requestMusique);
			this.stage.addEventListener(Event.ENTER_FRAME, verifieChargement);
			loaderPlayer1.contentLoaderInfo.addEventListener(Event.COMPLETE, ChargementTermineP1);
			loaderPlayer2.contentLoaderInfo.addEventListener(Event.COMPLETE, ChargementTermineP2);
			loaderNiveau.contentLoaderInfo.addEventListener(Event.COMPLETE, ChargementTermineStage);
			loaderPlayer1.load(requestPlayer1);
			loaderPlayer2.load(requestPlayer2);
			loaderNiveau.load(requestNiveau);
			this.removeEventListener(Event.ADDED_TO_STAGE, menuActif);
		}

		private function ChargementTermineP1(evt:Event):void
		{
			player1 = MovieClip(evt.target.content.getChildAt(0));
			player1.scaleX=player1.scaleY=0.4;
			player1.x=200;
			player1.y=625;
			player1.nom=(persoChoisi);
			etatChargement++;
		}
		
		private function ChargementTermineP2(evt:Event):void
		{
			player2 = MovieClip(evt.target.content.getChildAt(0));
			player2.scaleX=-0.4;
			player2.scaleY=0.4;
			player2.x=800;
			player2.y=625;
			player2.nom=(nomAdversaire);
			etatChargement++;
		}
		
		private function ChargementTermineStage(evt:Event):void
		{
			niveau = MovieClip(evt.target.content);
			niveau.gotoAndStop(nomNiveau);
			niveau.barre_p1.gotoAndStop(persoChoisi);
			niveau.barre_p2.gotoAndStop(nomAdversaire);
			etatChargement++;
		}
		
		
	/************* Vérification que tous les éléments sont chargés et démarrage du combat quand on appui sur ENTER *************/
		private function verifieChargement(evt:Event):void
		{
			if(etatChargement==3 && Main.fade.alpha <= 0){
			conteneurLoading.loadingVersus.gotoAndStop("etatEnter");
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN,toucheDown);
			leCombat=new Combat(player1, player2, niveau, musiqueNiveau);
			this.stage.removeEventListener(Event.ENTER_FRAME, verifieChargement);
			}

		}
		/************* Fondu noir et passage au combat *************/
		private function toucheDown(event:KeyboardEvent):void
		{
			var key:uint = event.keyCode;
			switch (key)
			{
				case Keyboard.ENTER :
					Main.fade.fadeOut();
					this.stage.removeEventListener(KeyboardEvent.KEY_DOWN,toucheDown);
					this.stage.addEventListener(Event.ENTER_FRAME, changeEcran);
					break;
			}

		}
		
		private function changeEcran(evt:Event):void
		{
			if (Main.fade.alpha >= 1)
			{
				
				this.parent.addChild(leCombat);
				Main.fade.fadeIn();
				this.stage.removeEventListener(Event.ENTER_FRAME, changeEcran);
				this.parent.removeChild(this);
			}

		}



	}
}