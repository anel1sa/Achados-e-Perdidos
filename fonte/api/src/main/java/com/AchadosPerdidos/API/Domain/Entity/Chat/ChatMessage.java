package com.AchadosPerdidos.API.Domain.Entity.Chat;

import com.AchadosPerdidos.API.Domain.Enum.Tipo_Menssagem;
import com.AchadosPerdidos.API.Domain.Enum.Status_Menssagem;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import java.time.LocalDateTime;

@Document(collection = "chat_messages")
public class ChatMessage {
    @Id
    private String id;
    private String Id_Chat;
    private String Id_Usuario_Destino;
    private String Id_Usuario_Remetente;
    private String Menssagem;
    private LocalDateTime Data_Hora_Menssagem;
    private Status_Menssagem Status;
    private Tipo_Menssagem Tipo;

    // Construtores
    public ChatMessage() {}

    public ChatMessage(String id, String Id_Chat, String Id_Usuario_Destino, String Id_Usuario_Remetente, String Menssagem, LocalDateTime Data_Hora_Menssagem, Status_Menssagem Status, Tipo_Menssagem Tipo) {
        this.id = id;
        this.Id_Chat = Id_Chat;
        this.Id_Usuario_Destino = Id_Usuario_Destino;
        this.Id_Usuario_Remetente = Id_Usuario_Remetente;
        this.Menssagem = Menssagem;
        this.Data_Hora_Menssagem = Data_Hora_Menssagem;
        this.Status = Status;
        this.Tipo = Tipo;
    }

    // Construtor customizado para inicialização padrão
    public ChatMessage(String chatId, String senderId, String receiverId, String menssagem, Tipo_Menssagem tipo, Status_Menssagem status) {
        this.Id_Chat = chatId;
        this.Id_Usuario_Remetente = senderId;
        this.Id_Usuario_Destino = receiverId;
        this.Menssagem = menssagem;
        this.Tipo = tipo;
        this.Status = status;
        this.Data_Hora_Menssagem = LocalDateTime.now();
    }

    // Getters e Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getId_Chat() { return Id_Chat; }
    public void setId_Chat(String Id_Chat) { this.Id_Chat = Id_Chat; }

    public String getId_Usuario_Destino() { return Id_Usuario_Destino; }
    public void setId_Usuario_Destino(String Id_Usuario_Destino) { this.Id_Usuario_Destino = Id_Usuario_Destino; }

    public String getId_Usuario_Remetente() { return Id_Usuario_Remetente; }
    public void setId_Usuario_Remetente(String Id_Usuario_Remetente) { this.Id_Usuario_Remetente = Id_Usuario_Remetente; }

    public String getMenssagem() { return Menssagem; }
    public void setMenssagem(String Menssagem) { this.Menssagem = Menssagem; }

    public LocalDateTime getData_Hora_Menssagem() { return Data_Hora_Menssagem; }
    public void setData_Hora_Menssagem(LocalDateTime Data_Hora_Menssagem) { this.Data_Hora_Menssagem = Data_Hora_Menssagem; }

    public Status_Menssagem getStatus() { return Status; }
    public void setStatus(Status_Menssagem Status) { this.Status = Status; }

    public Tipo_Menssagem getTipo() { return Tipo; }
    public void setTipo(Tipo_Menssagem Tipo) { this.Tipo = Tipo; }
}
