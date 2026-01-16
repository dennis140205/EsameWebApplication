import { ComponentFixture, TestBed } from '@angular/core/testing';

import { GestioneMercato } from './gestione-mercato';

describe('GestioneMercato', () => {
  let component: GestioneMercato;
  let fixture: ComponentFixture<GestioneMercato>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [GestioneMercato]
    })
    .compileComponents();

    fixture = TestBed.createComponent(GestioneMercato);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
