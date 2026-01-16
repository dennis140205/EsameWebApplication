import { ComponentFixture, TestBed } from '@angular/core/testing';

import { JoinLega } from './join-lega';

describe('JoinLega', () => {
  let component: JoinLega;
  let fixture: ComponentFixture<JoinLega>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [JoinLega]
    })
      .compileComponents();

    fixture = TestBed.createComponent(JoinLega);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
