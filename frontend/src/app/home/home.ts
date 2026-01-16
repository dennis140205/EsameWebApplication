import {Component, inject, OnInit} from '@angular/core';
import { RouterModule } from '@angular/router';
import { AuthService} from '../auth/auth.service';
import { UtenteDTO } from '../model/utente';
import { Stats } from '../service/stats';
import {NgClass} from '@angular/common';
import { NewsService } from '../service/news.service';
import { RigaClassifica, Marcatore } from '../model/stats';
import {NotificaService} from '../service/notifica.service';
@Component({
  selector: 'app-home',
  standalone: true,
  imports: [RouterModule, NgClass],
  templateUrl: './home.html',
  styleUrl: './home.css'
})
export class Home implements OnInit {
  currentUser: UtenteDTO | null = null;
  tabSelezionata: string = 'classifica';
  activeModalTab: string = 'classifica';
  top3Classifica: RigaClassifica[] = [];
  interaClassifica: RigaClassifica[] = [];
  marcatori: Marcatore[] = [];
  interimarcatori: Marcatore[] = [];
  notizieComplete: any[] = [];
  notizieVisualizzate: any[] = [];
  mostraTutte: boolean = false;
  notiziaSelezionata: any = null;

  giornataAttuale: number = 1;
  giornataNavigata: number = 1;
  calendarioMappa: any = {};
  mostraCalendario: boolean = false;
  private notificaService = inject(NotificaService);



  constructor(
    private authService: AuthService,
    private statsService: Stats,
    private newsService: NewsService) {
  }

  ngOnInit() {

    this.authService.checkAuthStatus().subscribe(isLogged => {
      if (isLogged) {
        this.currentUser = this.authService.getUserSnapshot();
      } else {
        this.currentUser = null;
      }
    });
    this.caricaClassifica();
    this.caricaMarcatori();
    this.caricaNews();
    this.caricaCalendario();
  }

  caricaCalendario() {
    // Recupera prima il numero della giornata ufficiale
    this.statsService.getInfoCompetizione().subscribe(res => {
      let giornataApi = res.currentSeason.currentMatchday;

      this.statsService.getCalendarioCompleto().subscribe(resCal => {
        const tutteLePartite = resCal.matches;
        const mappa: any = {};

        for (let match of tutteLePartite) {
          const g = match.matchday;
          if (!mappa[g]) {
            mappa[g] = [];
          }
          mappa[g].push(match);
        }

        this.calendarioMappa = mappa;

        const partiteGiornata = mappa[giornataApi];

        if (partiteGiornata && partiteGiornata.length > 0) {
          const giornataConclusa = partiteGiornata.every((m: any) => m.status === 'FINISHED');

          if (giornataConclusa) {
            giornataApi = Math.min(giornataApi + 1, 38);
          }
        }
        this.giornataAttuale = giornataApi;
        this.giornataNavigata = giornataApi;
      });
    });
  }

  cambiaGiornata(n: number) {
    const nuova = this.giornataNavigata + n;
    if (nuova >= 1 && nuova <= 38) this.giornataNavigata = nuova;
  }


  caricaNews() {
    this.newsService.getLatestNews().subscribe({
      next: (response) => {
        if (response && response.articles) {
          this.notizieComplete = response.articles;

          this.notizieVisualizzate = this.notizieComplete.slice(0, 3);
        }
      },
      error: (err) => console.error('Errore:', err)
    });
  }

  espandiNews() {
    this.mostraTutte = !this.mostraTutte;
    if (this.mostraTutte) {
      this.notizieVisualizzate = this.notizieComplete;
    } else {
      this.notizieVisualizzate = this.notizieComplete.slice(0, 3);
    }

  }

  caricaClassifica() {
    this.statsService.getSerieAStandings().subscribe({
      next: (response) => {
        if (response && response.standings && response.standings[0]) {
          const rawTable = response.standings[0].table;

          this.interaClassifica = rawTable.map((t: any) => ({
            pos: t.position,
            squadra: t.team.shortName || t.team.name, // Usa nome corto se c'è (es. "Inter" invece di "FC Internazionale Milano")
            pt: t.points,
            logo: t.team.crest,
            pg: t.playedGames,
            gf: t.goalsFor,
            gs: t.goalsAgainst,
            dr: t.goalDifference
          }));

          this.top3Classifica = this.interaClassifica.slice(0, 3);
        }
      },
      error: (err) => console.error('Errore caricamento classifica:', err)
    });
  }

  caricaMarcatori() {
    this.statsService.getSerieAScorers().subscribe({
      next: (response) => {
        if (response && response.scorers) {
          this.interimarcatori = response.scorers.map((s: any) => ({
            nome: s.player.name,
            squadra: s.team.shortName || s.team.tla,
            gol: s.goals,
            logo: s.team.crest
          }));
          this.marcatori = this.interimarcatori.slice(0, 3);
        }
      },
      error: (err) => console.error('Errore caricamento marcatori:', err)
    });
  }


  setTab(tab: string) {
    this.tabSelezionata = tab;
  }

  setModalTab(tab: string) {
    this.activeModalTab = tab;
  }

  apriDettagli(news: any) {
    this.notiziaSelezionata = news;
  }

  chiudiDettagli() {
    this.notiziaSelezionata = null;
  }

  logout() {
    this.notificaService.chiediConferma({
      titolo: "Sei sicuro?",
      messaggio: "Sei sicuro di voler proseguire con il logout?",
      testoConfirm: "ESCI",
      colore: "btn-danger",
      coloreAnnulla: "btn-secondary",
      azione: () => {
        this.authService.logout().subscribe(() => {
          this.currentUser = null;

          this.notificaService.mostra("Logout effettuato con successo. A presto!", "success");

          setTimeout(() => {
            window.location.reload();
          }, 3000);
        });
      }
    });
  }
}
