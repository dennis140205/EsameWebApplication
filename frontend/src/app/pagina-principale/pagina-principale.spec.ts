import { ComponentFixture, TestBed } from '@angular/core/testing';

import { PaginaPrincipale } from './pagina-principale';

describe('PaginaPrincipale', () => {
  let component: PaginaPrincipale;
  let fixture: ComponentFixture<PaginaPrincipale>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [PaginaPrincipale]
    })
    .compileComponents();

    fixture = TestBed.createComponent(PaginaPrincipale);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
