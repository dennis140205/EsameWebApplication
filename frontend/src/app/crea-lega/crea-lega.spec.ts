import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CreaLega } from './crea-lega';

describe('CreaLega', () => {
  let component: CreaLega;
  let fixture: ComponentFixture<CreaLega>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [CreaLega]
    })
    .compileComponents();

    fixture = TestBed.createComponent(CreaLega);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
