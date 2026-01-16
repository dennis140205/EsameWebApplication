import { ComponentFixture, TestBed } from '@angular/core/testing';
import { ProponiScambio } from './proponi-scambio';
import { HttpClientTestingModule } from '@angular/common/http/testing';
import { RouterTestingModule } from '@angular/router/testing';
import { FormsModule } from '@angular/forms';
import { ScambioService } from '../service/scambio.service';

describe('ProponiScambio', () => {
  let component: ProponiScambio;
  let fixture: ComponentFixture<ProponiScambio>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [
        ProponiScambio,
        HttpClientTestingModule,
        RouterTestingModule,
        FormsModule
      ],
      providers: [ScambioService]
    }).compileComponents();

    fixture = TestBed.createComponent(ProponiScambio);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
