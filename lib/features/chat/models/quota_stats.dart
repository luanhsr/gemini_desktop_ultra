/// # QuotaStats
///
/// Modelo utilizado para armazenar estatísticas ESTIMADAS locais de consumo
/// da aplicação.
///
/// ## Métricas Monitoradas
///
/// - RPM → Requisições realizadas no último minuto.
/// - TPM → Tokens utilizados no último minuto.
/// - RPD → Total de requisições realizadas no dia.
/// - LastRequestTime → Horário da última requisição.
///
/// ## Observações
/// - Auxilia no controle, mas **NÃO É uma fonte de verdade para limites de API.**
class QuotaStats {
  int rpm, tpm, rpd;
  DateTime? lastRequestTime;

  QuotaStats({
    this.rpm = 0,
    this.tpm = 0,
    this.rpd = 0,
    this.lastRequestTime,
  });
}
