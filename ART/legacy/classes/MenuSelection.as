package 
{
	import ChargeurCombat;

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

	public class MenuSelection extends Sprite
	{

		private var positionCadreSelect:uint;

		private var conteneurFondSelect:Sprite;
		private var loaderFondSelect:Loader;
		private var requeteFondSelect:URLRequest;

		private var loaderCadre:Loader;
		private var requeteCadre:URLRequest;
		private var conteneurCadre:MovieClip;

		private var loaderMusique:Loader;
		private var requeteMusique:URLRequest;

		private var loaderFrancis:Loader;
		private var loaderFernando:Loader;
		private var loaderMarcAndre:Loader;
		private var loaderMarcAntoine:Loader;

		private var requetePerso:URLRequest;
		private var conteneurPerso:MovieClip;

		private var persoChoisi:String;

		private var chargeurCombat:ChargeurCombat;


		/*************Mise en place et chargement des personnages, fond d'écran et musique*************/
		public function MenuSelection()
		{

			conteneurPerso=new MovieClip();
			conteneurCadre=new MovieClip();

			loaderCadre = new Loader();
			loaderCadre.contentLoaderInfo.addEventListener(Event.COMPLETE, chargeCadreFini);
			requeteCadre = new URLRequest("swf/cadre.swf");
			loaderCadre.load(requeteCadre);
			loaderCadre.x = 178;
			loaderCadre.y = 90;

			loaderFrancis=new Loader();
			loaderFrancis.contentLoaderInfo.addEventListener(Event.COMPLETE, chargeFini);
			requetePerso = new URLRequest("swf/perso_selection.swf");
			loaderFrancis.load(requetePerso);

			loaderMusique = new Loader();
			requeteMusique = new URLRequest("swf/musique_selection.swf");

			loaderFondSelect = new Loader();
			requeteFondSelect = new URLRequest("images/selection.jpg");
			loaderFondSelect.load(requeteFondSelect);

			this.addEventListener(Event.ADDED_TO_STAGE, menuActif);

		}

		private function chargeFini(evt:Event):void
		{
			conteneurPerso = MovieClip(evt.target.content.getChildAt(0));
			conteneurPerso.scaleX = conteneurPerso.scaleY = 0.35;
			conteneurPerso.x = 150;
			conteneurPerso.y = 635;

		}

		private function chargeCadreFini(evt:Event):void
		{

			conteneurCadre = MovieClip(evt.target.content);
			conteneurCadre.x = 178;
			conteneurCadre.y = 90;
		}

		/************* Lorsque le menu est ajouté au stage on ajoute le contenu et on démarre la musique *************/
		private function menuActif(evt:Event):void
		{
			loaderMusique.load(requeteMusique);
			positionCadreSelect = 1;
			conteneurFondSelect = new Sprite();
			conteneurFondSelect.addChild(loaderFondSelect);
			addChild(conteneurFondSelect);
			addChild(conteneurCadre);

			addChildAt(conteneurPerso, numChildren-1);
			//trace(this.parent.stage);
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, toucheDownSelect);
			this.removeEventListener(Event.ADDED_TO_STAGE, menuActif);
		}
		/************* gestion du clavier pour déplacer la sélection et pour la touche ENTER *************/
		private function toucheDownSelect(event:KeyboardEvent):void
		{
			var key:uint = event.keyCode;
			switch (key)
			{
				case Keyboard.LEFT :
					if (positionCadreSelect == 1)
					{
						positionCadreSelect = 4;
						conteneurPerso.gotoAndStop("propheteStance");
						conteneurCadre.x = 627;
						conteneurCadre.y = 91;

					}
					else if (positionCadreSelect == 2)
					{
						positionCadreSelect = 1;
						conteneurPerso.gotoAndStop("professeurStance");
						conteneurCadre.x = 178;
						conteneurCadre.y = 90;

					}
					else if (positionCadreSelect == 3)
					{
						positionCadreSelect = 2;
						conteneurPerso.gotoAndStop("slapshotStance");
						conteneurCadre.x = 295;
						conteneurCadre.y = 324;

					}
					else if (positionCadreSelect == 4)
					{
						positionCadreSelect = 3;
						conteneurPerso.gotoAndStop("ponchoStance");
						conteneurCadre.x = 510;
						conteneurCadre.y = 324;

					}

					break;
				case Keyboard.RIGHT :
					if (positionCadreSelect == 1)
					{
						positionCadreSelect = 2;
						conteneurPerso.gotoAndStop("slapshotStance");
						conteneurCadre.x = 295;
						conteneurCadre.y = 324;

					}
					else if (positionCadreSelect == 2)
					{
						positionCadreSelect = 3;
						conteneurPerso.gotoAndStop("ponchoStance");
						conteneurCadre.x = 510;
						conteneurCadre.y = 324;

					}
					else if (positionCadreSelect == 3)
					{
						positionCadreSelect = 4;
						conteneurPerso.gotoAndStop("propheteStance");
						conteneurCadre.x = 627;
						conteneurCadre.y = 91;

					}
					else if (positionCadreSelect == 4)
					{
						positionCadreSelect = 1;
						conteneurPerso.gotoAndStop("professeurStance");
						conteneurCadre.x = 178;
						conteneurCadre.y = 90;

					}
					break;
				case Keyboard.ENTER :
					conteneurCadre.cadreMC.gotoAndPlay("down");
					switch (positionCadreSelect)
					{
						case 1 :
							persoChoisi = "professeur";
							conteneurPerso.gotoAndStop("professeurVictory");
							if (conteneurPerso.professeurVictory != null)
							{
								conteneurPerso.professeurVictory.addEventListener(Event.ENTER_FRAME, finSelection);
							}
							Main.parcoursAdversaire = new Array("poncho","prophete","slapshot","professeur");
							break;
						case 2 :
							persoChoisi = "slapshot";
							
							conteneurPerso.gotoAndStop("slapshotVictory");
							if (conteneurPerso.slapshotVictory != null)
							{
								conteneurPerso.slapshotVictory.addEventListener(Event.ENTER_FRAME, finSelection);
							}
							Main.parcoursAdversaire = new Array("prophete","poncho","professeur","slapshot");
							break;
						case 3 :
							persoChoisi = "poncho";
							conteneurPerso.gotoAndStop("ponchoVictory");
							if (conteneurPerso.ponchoVictory != null)
							{
								conteneurPerso.ponchoVictory.addEventListener(Event.ENTER_FRAME, finSelection);
							}
							
							Main.parcoursAdversaire = new Array("professeur","slapshot","prophete","poncho");
							break;
						case 4 :
							persoChoisi = "prophete";
							conteneurPerso.gotoAndStop("propheteVictory");
							if (conteneurPerso.propheteVictory != null)
							{
								conteneurPerso.propheteVictory.addEventListener(Event.ENTER_FRAME, finSelection);
							}
							Main.parcoursAdversaire = new Array("slapshot","professeur","poncho","prophete");
							break;
					}
					chargeurCombat = new ChargeurCombat(persoChoisi);
					this.stage.removeEventListener(KeyboardEvent.KEY_DOWN, toucheDownSelect);
					
					break;
			}
		}

		private function finSelection(evt:Event):void
		{
			if (evt.currentTarget.currentFrame >= evt.currentTarget.totalFrames)
			{
				Main.fade.fadeOut();
				evt.currentTarget.removeEventListener(Event.ENTER_FRAME, finSelection);
				this.stage.addEventListener(Event.ENTER_FRAME, changeEcran);
			}
		}

		private function changeEcran(evt:Event):void
		{
			if (Main.fade.alpha >= 1)
			{
				loaderMusique.unloadAndStop();
				this.parent.addChild(chargeurCombat);
				Main.fade.fadeIn();
				this.stage.removeEventListener(Event.ENTER_FRAME, changeEcran);
				this.parent.removeChild(this);
			}

		}

	}
}