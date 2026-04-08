class QuotaStats {
  int rpm; // Mensagens no último minuto
  int tpm; // Tokens no último minuto
  int rpd; // Total de mensagens hoje
  DateTime? lastRequestTime;

  QuotaStats({
    this.rpm = 0,
    this.tpm = 0,
    this.rpd = 0,
    this.lastRequestTime,
  });
}
// aqui é o modelo de estatísticas de cota, que rastreia o número de mensagens e tokens usados em um determinado período, bem como a hora da última solicitação.
// o Google ai studio oferece esse tipo de estatísticas para ajudar os desenvolvedores a monitorar o uso da API e garantir que eles não excedam os limites estabelecidos.
// todavia essa implementação é apenas um modelo local, e não está conectada a nenhuma API real para obter dados de uso. Mas tera uma metrica visual aproximada. 