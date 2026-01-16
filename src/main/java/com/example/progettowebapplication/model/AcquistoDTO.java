package com.example.progettowebapplication.model;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class AcquistoDTO {
    private Long id;
    private Long idFantasquadra;
    private Long idCalciatore;
    private int prezzoAcquisto;
    private LocalDateTime dataAcquisto;
    private Long idLega;
}