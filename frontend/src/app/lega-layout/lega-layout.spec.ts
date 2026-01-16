import { ComponentFixture, TestBed } from '@angular/core/testing';

import { LegaLayoutComponent } from './lega-layout';

describe('LegaLayout', () => {
  let component: LegaLayoutComponent;
  let fixture: ComponentFixture<LegaLayoutComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [LegaLayoutComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(LegaLayoutComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
