import { ComponentFixture, TestBed } from '@angular/core/testing';

import { ImpostazioniLega } from './impostazioni-lega';

describe('ImpostazioniLega', () => {
  let component: ImpostazioniLega;
  let fixture: ComponentFixture<ImpostazioniLega>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [ImpostazioniLega]
    })
    .compileComponents();

    fixture = TestBed.createComponent(ImpostazioniLega);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
