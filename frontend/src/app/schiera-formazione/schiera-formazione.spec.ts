import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SchieraFormazione } from './schiera-formazione';

describe('SchieraFormazione', () => {
  let component: SchieraFormazione;
  let fixture: ComponentFixture<SchieraFormazione>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [SchieraFormazione]
    })
    .compileComponents();

    fixture = TestBed.createComponent(SchieraFormazione);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
