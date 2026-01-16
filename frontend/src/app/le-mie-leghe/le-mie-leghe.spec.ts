import { ComponentFixture, TestBed } from '@angular/core/testing';

import { LeMieLeghe } from './le-mie-leghe';

describe('LeMieLeghe', () => {
  let component: LeMieLeghe;
  let fixture: ComponentFixture<LeMieLeghe>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [LeMieLeghe]
    })
    .compileComponents();

    fixture = TestBed.createComponent(LeMieLeghe);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
