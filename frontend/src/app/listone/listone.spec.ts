import { ComponentFixture, TestBed } from '@angular/core/testing';

import { Listone } from './listone';

describe('Listone', () => {
  let component: Listone;
  let fixture: ComponentFixture<Listone>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [Listone]
    })
    .compileComponents();

    fixture = TestBed.createComponent(Listone);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
