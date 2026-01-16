package com.example.progettowebapplication.model;
// Serve per contenere anche quei dati che nella tabella lega non ci sono come ruolo
public class LegaRiepilogo {
    private int id;
    private String nome;
    private String ruolo;
    private String iscritti;
    private String prossimoTurno;

    public LegaRiepilogo(int id, String nome, String ruolo, String iscritti, String prossimoTurno) {
        this.id = id;
        this.nome = nome;
        this.ruolo = ruolo;
        this.iscritti = iscritti;
        this.prossimoTurno = prossimoTurno;
    }

    // Getter e setter
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public String getRuolo() { return ruolo; }
    public void setRuolo(String ruolo) { this.ruolo = ruolo; }

    public String getIscritti() { return iscritti; }
    public void setIscritti(String iscritti) { this.iscritti = iscritti; }

    public String getProssimoTurno() { return prossimoTurno; }
    public void setProssimoTurno(String prossimoTurno) { this.prossimoTurno = prossimoTurno; }
}