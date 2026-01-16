import { Routes } from '@angular/router';
import { Home } from './home/home';
import {Register} from './register/register'
import {Login} from './login/login'
import { JoinLega } from './join-lega/join-lega';
import {CreaLega} from './crea-lega/crea-lega';
import {PaginaPrincipale} from './pagina-principale/pagina-principale';
import {Profilo} from './profilo/profilo';
import {Admin} from './admin/admin';
import {Listone} from './listone/listone';
import{MiaRosa} from './mia-rosa/mia-rosa';
import {LeMieLeghe} from './le-mie-leghe/le-mie-leghe';
import{Scambi} from './scambi/scambi';
import{GestioneMercato} from './gestione-mercato/gestione-mercato';
import {SchieraFormazione} from './schiera-formazione/schiera-formazione';
import { LegaLayoutComponent } from './lega-layout/lega-layout';
import {ImpostazioniLega} from './impostazioni-lega/impostazioni-lega';
import {ProponiScambio} from './proponi-scambio/proponi-scambio';
import {RisultatiLega} from './risultati/risultati';
import {AuthGuard} from './auth/auth-guard';

export const routes: Routes = [
  { path: '', component: Home },
  { path: 'register', component: Register },
  { path: 'login', component: Login },
  { path: 'join-lega', component: JoinLega },
  { path: 'crea-lega', component: CreaLega },
  { path: 'le-mie-leghe', component: LeMieLeghe },
  { path: 'admin', component: Admin },
  { path: 'profilo', component: Profilo },
  { path: 'profilo/:idLega', component: Profilo },
  {
    path: 'lega/:idLega',
    component: LegaLayoutComponent,
    children: [

      { path: '', redirectTo: 'dashboard', pathMatch: 'full' },

      { path: 'dashboard', component: PaginaPrincipale },

      { path: 'rosa', component: MiaRosa },

      {path: 'risultati', component: RisultatiLega},
      { path: 'listone', component: Listone },

      { path: 'scambi', component: Scambi },

      { path: 'formazione', component: SchieraFormazione },

      { path: 'gestione-mercato', component: GestioneMercato },
      {path: 'impostazioni-lega',component:ImpostazioniLega},
      { path: 'proponi-scambio', component: ProponiScambio },

    ]
  }
];
