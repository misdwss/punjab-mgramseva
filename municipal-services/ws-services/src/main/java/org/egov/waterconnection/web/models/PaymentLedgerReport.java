package org.egov.waterconnection.web.models;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class PaymentLedgerReport
{
    @JsonProperty("paymentCollectionDate")
    private String collectionDate;

    @JsonProperty("receiptNo")
    private String receiptNo;

    @JsonProperty("amountPaid")
    private BigDecimal paid;

    @JsonProperty("balanceLeft")
    private BigDecimal balanceLeft;
}
