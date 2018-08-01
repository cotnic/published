package com.cotnic.model;

public class ClientModel {

    private String id;

    private int counter;

    private Long firstAcces;

    public ClientModel(String id, int counter, Long firstAcces) {
        this.id = id;
        this.counter = counter;
        this.firstAcces = firstAcces;
    }

    public int getCounter() {
        return counter;
    }

    public void setCounter(int counter) {
        this.counter = counter;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Long getFirstAcces() {
        return firstAcces;
    }

    public void setFirstAcces(Long firstAcces) {
        this.firstAcces = firstAcces;
    }
}
