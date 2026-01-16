import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RisultatiLega } from './risultati';

describe('Risultati', () => {
  let component: RisultatiLega;
  let fixture: ComponentFixture<RisultatiLega>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [RisultatiLega]
    })
    .compileComponents();

    fixture = TestBed.createComponent(RisultatiLega);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
