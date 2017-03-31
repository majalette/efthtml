package 
{

	import MenuStart;
	import FadeToBlack;

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

	public class Main extends Sprite
	{

		private var introduction:Intro;
		public static var fade:FadeToBlack;
		
		/*************Tableau associatif qui indique le niveau à charger selon l'adversaire*************/
		public static var niveau:Object = {professeur:"bibliotheque",slapshot:"arena",poncho:"hochelaga",prophete:"desert"};
		
		/*************Tableau qui va contenir l'ordre des adversaires à afronter selon le personnage choisi par le joueur*************/
		public static var parcoursAdversaire:Array = [];

		/************Numéro de l'ennemi auquel le joueur est rendu (de 0 a 3)**************/
		public static var ennemi:int = 0;
		
		/************Identifiant de la ronde du combat (ce sont des 2 de 3)**************/
		public static var leRound:int = 1;
		
		/************Identifiant du nombre de victoires**************/
		public static var victoire:int = 0;

		public function Main()
		{
			/************Gestionnaire pour les fondu au noir***********/
			fade = new FadeToBlack  ;
			addChildAt(fade, 0);

			/*************Ajout de l'animation d'introduction(Fukushima Games)*************/
			introduction = new Intro();
			addChild(introduction);

		}


	}
}