import { ComponentFixture, TestBed } from '@angular/core/testing';

import { MiaRosa } from './mia-rosa';

describe('MiaRosa', () => {
  let component: MiaRosa;
  let fixture: ComponentFixture<MiaRosa>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [MiaRosa]
    })
    .compileComponents();

    fixture = TestBed.createComponent(MiaRosa);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
