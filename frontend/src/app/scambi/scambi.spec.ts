import { ComponentFixture, TestBed } from '@angular/core/testing';
import { Scambi } from './scambi'; // Importa la tua classe
import { HttpClientTestingModule } from '@angular/common/http/testing';
import { RouterTestingModule } from '@angular/router/testing';
import { ScambioService } from '../service/scambio.service';
import { ActivatedRoute } from '@angular/router';
import { of } from 'rxjs';

describe('Scambi Component', () => {
  let component: Scambi;
  let fixture: ComponentFixture<Scambi>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      // Importiamo i moduli di test per simulare HTTP e Router
      imports: [
        HttpClientTestingModule,
        RouterTestingModule,
        Scambi // Essendo standalone si mette negli imports
      ],
      providers: [
        ScambioService,
        {
          provide: ActivatedRoute,
          useValue: {
            // Simuliamo il parametro idLega che il tuo componente si aspetta
            parent: {
              snapshot: { paramMap: { get: () => '1' } }
            }
          }
        }
      ]
    }).compileComponents();

    fixture = TestBed.createComponent(Scambi);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('dovrebbe creare il componente', () => {
    expect(component).toBeTruthy();
  });
});
