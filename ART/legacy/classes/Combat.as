package 
{

	import Controls;
	import Adversaire;
	import Fin;

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
	import flash.media.SoundChannel;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class Combat extends Sprite
	{

		private var player1:MovieClip;
		private var player2:MovieClip;
		private var niveau:MovieClip;
		private var musique:Sound;
		private var ctrlMusique:SoundChannel;
		private var chrono:Timer;
		private var roundTimer:Timer;
		private var winTimer:Timer;
		private var changeRoundTimer:Timer;
		private var secondes:int = 99;
		private var controleClavier:Controls;
		private var controleAdversaire:Adversaire;
		private var gagnant:String;
		private var prochainRound:Combat;
		private var prochainEnnemi:ChargeurCombat;
		private var finDuJeu:Fin;

		
		public function Combat(_player1:MovieClip,_player2:MovieClip,_niveau:MovieClip,_musique:Sound)
		{
			player1 = _player1;
			player2 = _player2;
			niveau = _niveau;
			musique = _musique;
			ctrlMusique = new SoundChannel  ;
			chrono = new Timer(1000,99);
			roundTimer = new Timer(2000,1);
			this.addEventListener(Event.ADDED_TO_STAGE,combatActif);
			this.addEventListener(Event.REMOVED_FROM_STAGE,combatInactif);
		}

		/************* Lorsque le combat est ajouté au stage on place nos 2 personnages et on dématrre la musique *************/
		private function combatActif(evt:Event):void
		{
			addChild(niveau);
			addChild(player2);
			addChild(player1);
			ctrlMusique = musique.play();
			niveau.leRound.gotoAndStop("round" + String(Main.leRound));
			roundTimer.addEventListener(TimerEvent.TIMER,enleverRound);
			roundTimer.start();
		}

		private function combatInactif(evt:Event):void
		{
			roundTimer.removeEventListener(TimerEvent.TIMER,enleverRound);

		}
		
		/************* Lorsque l'image du round est restée 2 secondes, on l'enleve et on affiche FIGHT, puis on donne le controle au joueur *************/
		private function enleverRound(evt:TimerEvent):void
		{
			niveau.leRound.gotoAndStop(1);
			niveau.fight.play();
			chrono.addEventListener(TimerEvent.TIMER,decompteChrono);
			chrono.start();
			controleClavier = new Controls(player1,player2,niveau.barre_p2.vie);
			addChild(controleClavier);
			controleAdversaire = new Adversaire(player1,player2,niveau.barre_p1.vie);
			addChild(controleAdversaire);
			addEventListener(Event.ENTER_FRAME,barreDeVie);
			roundTimer.removeEventListener(TimerEvent.TIMER,enleverRound);
		}

		/************* ENTER FRAME qui verifie la barre de vie et qui détermine quel joueur a perdu *************/
		private function barreDeVie(evt:Event):void
		{
			if (niveau.barre_p2.vie.scaleX <= 0)
			{
				gagnant = player1.nom;
				niveau.finish.play();
				removeChild(controleAdversaire);
				niveau.barre_p2.vie.scaleX = 0;
				player2.gotoAndStop("dizzy");
				removeEventListener(Event.ENTER_FRAME,barreDeVie);
				addEventListener(Event.ENTER_FRAME,finishHimP1);
			}
			else if (niveau.barre_p1.vie.scaleX <= 0)
			{
				gagnant = player2.nom;
				niveau.finish.play();
				removeChild(controleClavier);
				niveau.barre_p1.vie.scaleX = 0;
				player1.gotoAndStop("dizzy");
				removeEventListener(Event.ENTER_FRAME,barreDeVie);
				addEventListener(Event.ENTER_FRAME,finishHimP2);
			}
		}

		private function finishHimP1(evt:Event):void
		{
			if (niveau.barre_p2.vie.scaleX < 0)
			{
				Main.victoire++;
				niveau.logop1.gotoAndStop("on");
				niveau.barre_p2.vie.scaleX = 0;
				player2.gotoAndStop("tomber");
				removeChild(controleClavier);
				chrono.stop();
				winTimer = new Timer(1000,1);
				winTimer.addEventListener(TimerEvent.TIMER,afficheGagnant);
				winTimer.start();

				removeEventListener(Event.ENTER_FRAME,finishHimP1);
			}
		}

		private function finishHimP2(evt:Event):void
		{
			if (niveau.barre_p1.vie.scaleX < 0)
			{
				niveau.barre_p1.vie.scaleX = 0;
				niveau.logop2.gotoAndStop("on");
				player1.gotoAndStop("tomber");
				removeChild(controleAdversaire);
				chrono.stop();
				winTimer = new Timer(1000,1);
				winTimer.addEventListener(TimerEvent.TIMER,afficheGagnant);
				winTimer.start();
				removeEventListener(Event.ENTER_FRAME,finishHimP2);
			}
		}
		/************* Affichage du nom du gagnant *************/
		private function afficheGagnant(evt:TimerEvent):void
		{
			if (niveau.barre_p1.vie.scaleX < niveau.barre_p2.vie.scaleX)
			{
				player2.gotoAndStop("victory");
			}
			else
			{
				player1.gotoAndStop("victory");
			}
			niveau.win.gotoAndStop(gagnant);
			changeRoundTimer = new Timer(2500,1);
			changeRoundTimer.addEventListener(TimerEvent.TIMER,finRound);
			changeRoundTimer.start();
			winTimer.removeEventListener(TimerEvent.TIMER,afficheGagnant);
		}

	/************* Vérification du nombre de victoires et de round, puis passage au round suivant *************/
		private function finRound(evt:TimerEvent):void
		{
			switch (Main.leRound)
			{
				case 1 :
					prochainRound = new Combat(player1,player2,niveau,musique);
					Main.leRound = 2;
					Main.fade.fadeOut();
					this.stage.addEventListener(Event.ENTER_FRAME,changeEcran);
					changeRoundTimer.removeEventListener(TimerEvent.TIMER,finRound);
					break;
				case 2 :
					if (Main.victoire == 1)
					{
						prochainRound = new Combat(player1,player2,niveau,musique);
						Main.leRound = 3;
						Main.fade.fadeOut();
						this.stage.addEventListener(Event.ENTER_FRAME,changeEcran);
						changeRoundTimer.removeEventListener(TimerEvent.TIMER,finRound);
					}
					else if (Main.victoire == 2)
					{
						Main.ennemi++;
						if (Main.ennemi == 4)
						{
							finDuJeu = new Fin(player1.nom);
							Main.fade.fadeOut();
							this.stage.addEventListener(Event.ENTER_FRAME,finJeu);
						}
						else
						{
							prochainEnnemi = new ChargeurCombat(player1.nom);
							Main.leRound = 1;
							Main.victoire = 0;
							Main.fade.fadeOut();
							this.stage.addEventListener(Event.ENTER_FRAME,changeAdversaire);
							changeRoundTimer.removeEventListener(TimerEvent.TIMER,finRound);
						}
					}
					else
					{
						Main.fade.fadeOut();
						this.stage.addEventListener(Event.ENTER_FRAME,finPartie);
						changeRoundTimer.removeEventListener(TimerEvent.TIMER,finRound);
					}
					break;
				case 3 :
					if (Main.victoire == 2)
					{
						Main.ennemi++;
						prochainEnnemi = new ChargeurCombat(player1.nom);
						Main.leRound = 1;
						Main.victoire = 0;
						Main.fade.fadeOut();
						this.stage.addEventListener(Event.ENTER_FRAME,changeAdversaire);
						changeRoundTimer.removeEventListener(TimerEvent.TIMER,finRound);
					}
					else
					{
						Main.fade.fadeOut();
						this.stage.addEventListener(Event.ENTER_FRAME,finPartie);
						changeRoundTimer.removeEventListener(TimerEvent.TIMER,finRound);
					}
					break;
			}
		}


		/************* passage au round suivant *************/
		private function changeEcran(evt:Event):void
		{
			if (Main.fade.alpha >= 1)
			{
				niveau.fight.gotoAndStop(1);
				ctrlMusique.stop();
				niveau.chrono_txt.text = 99;
				niveau.win.gotoAndStop(1);
				niveau.finish.gotoAndStop(1);
				niveau.barre_p1.vie.scaleX = niveau.barre_p2.vie.scaleX = 1;
				player1.gotoAndStop(1);
				player2.gotoAndStop(1);
				player1.x = 200;
				player1.y = 625;
				player2.x = 800;
				player2.y = 625;
				this.parent.addChild(prochainRound);
				Main.fade.fadeIn();
				this.stage.removeEventListener(Event.ENTER_FRAME,changeEcran);
				this.parent.removeChild(this);
			}

		}

		/************* Si 2 victoires on été accumulée, passage à l'ennemi suivant *************/
		private function changeAdversaire(evt:Event):void
		{
			if (Main.fade.alpha >= 1)
			{
				niveau.logop1.gotoAndStop("off");
				niveau.logop2.gotoAndStop("off");
				niveau.fight.gotoAndStop(1);
				ctrlMusique.stop();
				niveau.chrono_txt.text = 99;
				niveau.win.gotoAndStop(1);
				niveau.finish.gotoAndStop(1);
				niveau.barre_p1.vie.scaleX = niveau.barre_p2.vie.scaleX = 1;
				player1.gotoAndStop(1);
				player2.gotoAndStop(1);
				player1.x = 200;
				player1.y = 625;
				player2.x = 800;
				player2.y = 625;
				this.parent.addChild(prochainEnnemi);
				Main.fade.fadeIn();
				this.stage.removeEventListener(Event.ENTER_FRAME,changeAdversaire);
				this.parent.removeChild(this);
			}

		}

		/************* si vous avez perdu 2 fois contre 1 ennemi, GAMEOVER *************/
		private function finPartie(evt:Event):void
		{
			if (Main.fade.alpha >= 1)
			{
				niveau.gotoAndStop("gameover");
				this.removeChild(player1);
				this.removeChild(player2);
				Main.fade.fadeIn();
				this.stage.removeEventListener(Event.ENTER_FRAME,finPartie);
			}

		}
		/************* si les 4 ennemis ont été vaincus, passage à la fin du jeu *************/
		private function finJeu(evt:Event):void
		{
			if (Main.fade.alpha >= 1)
			{
				this.removeChild(player1);
				this.removeChild(player2);
				ctrlMusique.stop();
				finDuJeu.x=500;
				finDuJeu.y=325;
				this.parent.addChild(finDuJeu);
				Main.fade.fadeIn();
				this.stage.removeEventListener(Event.ENTER_FRAME,finJeu)
				this.parent.removeChild(this);;
			}

		}
		/************* Chronometre en haut *************/
		private function decompteChrono(evt:TimerEvent):void
		{
			secondes--;
			if (secondes < 10)
			{
				niveau.chrono_txt.text = "0" + String(secondes);
			}
			else
			{
				niveau.chrono_txt.text = String(secondes);
			}
			
		}

	}

}